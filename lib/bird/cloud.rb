require 'thor'
require 'bird'
require 'user_config'
require 'vcloud-rest/connection'
require 'bird/domain/vapp'

class Bird::Cloud < Thor
  include Bird #includes global config.  todo: move to config module?

  default_task :control
  def initialize(*args)
    super
    login
  end
  # Hack to override the help message produced by Thor.
  # With PR $387 this causes unexpected behaviour
  # https://github.com/wycats/thor/issues/261#issuecomment-16880836
  # def self.banner(command, namespace = nil, subcommand = 'list')
  #   "#{basename} list #{command.usage}"
  # end


  desc "list", "[--vapp] list restricted to: vApp <name> - NOT IMPLEMENTED"
  option :vapp, :banner => " vApp name"
  option :vm, :banner => " vm name"
  def list
    error("Sorry buddy, I haven't been imlplemented yet.")
  end

  desc "search [something]", "<name> - NOT IMPLEMENTED"
  option :vapp, :banner => " vApp name"
  option :vm, :banner => " vm name"
  def search(arg)#no args accepted, but thor breaks if no arg value here!
    return unless validate_search_args?(options)
    #todo: vcloud get org
    #unless config[:vcloud][:org]
    #  query vcloud api for orgs.
    #   If 1, store and move on.
    #   else
    org = get_orgid
    #end

    select_vdc_from_org

    # find vapp
    say "yay look its an org: #{org}"

    error("Sorry buddy, I haven't been imlplemented yet. I was just toying with you.... ")
  end




  desc "snapshot", "[--vm] snapshot something - NOT IMPLEMENTED"
  def snapshot
    error("Sorry buddy, I haven't been imlplemented yet.")
  end

  desc "restore", "[--vm] restore something - NOT IMPLEMENTED"
  def restore
    error("Sorry buddy, I haven't been imlplemented yet.")
  end

  desc "deploy", "[--vm] deploy something - NOT IMPLEMENTED"
  def deploy
    error("Sorry buddy, I haven't been imlplemented yet.")
  end

  desc "control", "No Args accepted.  Use this, and I'll hold your hand through the process"
  def control
    org_name = get_organization_name
    vdc_id = get_vdc_id_from_org_name(org_name)
    vapp_id = get_vapp_id_from_vdc_id(vdc_id)
    vm_id = get_vm_id_from_vapp_id(vapp_id)

    say("Success!!! I have my VM Name")
  end

  private



  def get_organization_name
    org = config[:vcloud][:org]
    unless org
      say "getting organization...."
      # "Getting Organizations accessible by user ..."
      orgs = @connection.get_organizations

      # if orgs.count then skip the following
      #psuedo : key, value = hash.first
      selection = select_name(orgs)
      org = selection[0]
      config[:vcloud][:org] = selection[0]

      store_org = yes? "Remember this selection? \n(you can override with the `bird setup --vorg <new org>` command\n y\\n? "
      if store_org
        config[:vcloud][:org] = org
        config.save
        ok "stored configs for vCloud Org: #{config[:vcloud][:org]}"
      end
    end
    say "using org: #{org}"
    org
  end






  def validate_search_args?(options)
    result = 0
    result += 1 if options[:vapp]
    result += 1 if options[:vm]
    if result == 0 then
      error("I need something to search for. [--vapp | --vm]")
      result = false
    elsif result == 2
      error("uhm, you're confusing me.  Do you want me to search for a vapp or a vm? Please send only one!")
      result = false
    end
    result
  end

  def select_name(choices)
    choices = choices.map.with_index{ |a, i| [i+1, *a]}
    print_table choices
    selection = ask("Pick one:").to_i
    selected = choices[selection-1][1]
    ok("selected: #{selected}")
    return selected #result is an array
  end

  def select_name_and_id(choices)
    choices = choices.map.with_index{ |a, i| [i+1, *a]}
    print_table choices
    selection = ask("Pick one:").to_i
    selected = choices[selection-1]
    selected.shift
    ok("selected: #{selected} -- array count: selected.count")
    return selected #result is an array
  end

  #TODO: refactor to DDD and model objects, separate repository.
  def get_vdc_id_from_org_name(org_name)

    vdc_id = config[:vcloud][:vdcid]
    unless vdc_id
      say "I need to know which vdc to use . . ."
      org = @connection.get_organization_by_name(org_name)

      # if orgs.count then skip the following
      #psuedo : key, value = hash.first
      selection = select_name_and_id(org[:vdcs])
      error selection

      vdc_name = selection[0]
      vdc_id = selection[1]
      config[:vcloud][:vdc] = vdc_name
      config[:vcloud][:vdcid] = vdc_id

      store_org = yes? "Remember this selection? \n(you can override with the `bird setup --vdc <new org>` command\n y\\n? "
      if store_org
        config[:vcloud][:vdc] = vdc_name
        config[:vcloud][:vdcid] = vdc_id
        config.save
        ok "stored configs for vCloud Org: #{config[:vcloud][:vdcid]}"
      end
    end
    say "using vdc: #{vdc_name}"
    vdc_id
  end

  def get_vapp_id_from_vdc_id(vdc_id)
    vapp_id = config[:vcloud][:vappid]
    unless vapp_id
      say "I need to know which vapp to use . . ."
      vdc = @connection.get_vdc(vdc_id)

      # if orgs.count then skip the following
      #psuedo : key, value = hash.first

      selection = select_name_and_id(vdc[:vapps])

      vapp_name = selection[0]
      vapp_id = selection[1]
      config[:vcloud][:vappname] = vapp_name
      config[:vcloud][:vappid] = vapp_id

      # store_org = yes? "Remember this selection? \n(you can override with the `bird setup --vdc <new org>` command\n y\\n? "
      # if store_org
      #   config[:vcloud][:vdc] = vdc_name
      #   config.save
      #   ok "stored configs for vCloud Org: #{config[:vcloud][:vdc]}"
      # end
    end
    say "using vapp: #{vapp_name}"
    vapp_id
  end

  def get_vm_id_from_vapp_id(vapp_id)

    vm_id = config[:vcloud][:vmid]
    unless vm_id
      say "I need to know which vm to use . . ."
      vappHash = @connection.get_vapp(vapp_id)
      vapp = Bird::Vapp.new(vappHash)

      # if orgs.count then skip the following
      #psuedo : key, value = hash.first
      # TODO: convert vdc[:vapps] to a name => ID hash

      selection = select_name_and_id(vapp.vms_hash)

      vm_id = selection[1]
      vm_name = selection[0]
      config[:vcloud][:vm] = vm_name
      config[:vcloud][:vmid] = vm_id

      # store_org = yes? "Remember this selection? \n(you can override with the `bird setup --vdc <new org>` command\n y\\n? "
      # if store_org
      #   config[:vcloud][:vdc] = vdc_name
      #   config.save
      #   ok "stored configs for vCloud Org: #{config[:vcloud][:vdc]}"
      # end
    end
    say "using vdc: #{vm_name},  #{vm_id}"
    vm_id
  end


  def to_be_implemented

    # ### Fetch and show a vApp, Dev Sandbox is an example, you should replace it with your own vDC

    puts "### Fetch and Show 'Dev Sandbox, Database Hosts"
    vApp = connection.get_vapp(vdc[:vapps]["Dev Sandbox"])
    ap vApp

  end

  def login
    host = config[:vcloud][:host]
    user = config[:vcloud][:user]
    pass = config[:vcloud][:pass]
    org = config[:vcloud][:org]
    api = "1.5"

    say config[:vcloud]
    @connection = VCloudClient::Connection.new("https://#{host}", user, pass, org, api)
    ok "login to #{config[:vcloud][:host]} . . . "
    @connection.login
    ok "  . . . successful"
    ObjectSpace.define_finalizer(self, proc { logout })
  end

  def logout
    @connection.logout
    say "logged out!"
  end


  def em(text)
    shell.set_color(text, nil, true)
  end

  def ok(msg=nil)
    text = msg ? "#{msg}" : "OK"
    say "#{msg}\r", :green
  end

  def error(msg)
    say "#{msg}\r", :red
  end

end

