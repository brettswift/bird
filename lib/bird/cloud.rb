require 'thor'
require 'bird'
require 'user_config'
require 'vcloud-rest/connection'

class Bird::Cloud < Thor
  include Bird #includes global config.  todo: move to config module?

  default_task :list

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
        org = get_org    
    #end
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

  private

  def select_vdc_from_org

    # vdc_key = answer
  end

  def get_org
    org = config[:vcloud][:org]
    unless org
      org = select_something(["asdf","qwer","IDEV7129"])
      ok "you selected: #{org}"
      store_org = yes? "Remember this selection? \n(you can override with the `bird setup --vorg <new org>` command\n y\\n? "
      config[:vcloud][:org] = org if store_org
      ok "stored #{config[:vcloud][:org]}" if store_org
      config.save
    end
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

  def select_something(choices)
    choices = choices.map.with_index{ |a, i| [i+1, *a]}
    print_table choices
    selection = ask("Pick one:").to_i
    choices[selection-1][1]
  end


  def get_vcd
    host = config[:vcloud][:host]
    user = config[:vcloud][:user]
    pass = config[:vcloud][:pass]
    org = config[:vcloud][:org]
    api = "1.5"

    connection = VCloudClient::Connection.new(host, user, pass, org, api)
    connection.login

    # "Getting Organizations accessible by user ..."
    orgs = connection.get_organizations

    say "Getting #{config[:vcloud][:org]} Organization information ... "
    org = connection.get_organization(orgs["IDEV7129"])

    say "Fetch and Show 'IDEV7129_VDC_CGNO' vDC"
    vdc = connection.get_vdc(org[:vdcs]["IDEV7129_VDC_CGNO"])

  end

  # def login


  #   @connection = VCloudClient::Connection.new(host, user, pass, org, api)
  #   @connection.login
  # end

  # def logout
  #   @connection.logout
  # end


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


# host = 'https://vcd011no.lab.vim.dcs.mlb.inet'
# user = 'bswift'
# pass = 'asdfasdf'
# org  = 'IDEV7129'
# api  = '5.1'

# puts "#################################################################"
# puts "# vcloud-rest example"
# puts "#"
# puts "### Connect to vCloud"

# ### Connect to vCloud

# connection = VCloudClient::Connection.new(host, user, pass, org, api)
# connection.login

# ### Fetch a list of the organizations you have access to

# puts "### Fetch and List Organizations"
# orgs = connection.get_organizations
# ap orgs

# # ### Fetch and show an organization, COE is an example, you should replace it with your own organization

# puts "### Fetch and Show 'IDEV7129' Organization"
# org = connection.get_organization(orgs["IDEV7129"])
# ap org

# # ### Fetch and show a vDC, OvDC-PAYG-Bronze-01 is an example, you should replace it with your own vDC

# puts "### Fetch and Show 'IDEV7129_VDC_CGNO' vDC"
# vdc = connection.get_vdc(org[:vdcs]["IDEV7129_VDC_CGNO"])
# ap vdc

# # ### Fetch and show a vApp, Dev Sandbox is an example, you should replace it with your own vDC

# puts "### Fetch and Show 'Dev Sandbox, Database Hosts"
# vApp = connection.get_vapp(vdc[:vapps]["Dev Sandbox"])
# ap vApp
