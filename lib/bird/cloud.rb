require 'thor'
require 'thor/actions'
require 'bird'
require 'user_config'
require 'vcloud-rest/connection'
require 'bird/domain/vapp'

class Bird::Cloud < Thor
  include Bird #includes global config.  todo: move to config module?
  include Thor::Actions
  
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

  #TODO: Fix Subcommand functionality:  it thinks the command was bird poweroff,
  #       not `bird cloud poweroff`
  # desc "poweron", "[--vmid] powers on the vm given an ID."
  # def poweron
  #   action_vm(vm_id,'power-on')
  # end

  # desc "poweroff", "[--vmid] powers of the vm given an ID."
  # def poweroff
  #   action_vm(vm_id,'power-off')
  # end

  desc "snapshot", "[--vapp] snapshot something - NOT IMPLEMENTED"
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
    clear
    vm_id = get_vm_id_from_vapp_id(vapp_id)
    clear
    action_vm(vm_id)
  end

  private

  def get_organization_name
    org = config[:vcloud][:org]
    unless org
      alert "I need to know which organization to use . . ."
      orgs = @connection.get_organizations

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
    org
  end

  # TODO: make selection return if only one option exists
      #psuedo : key, value = hash.first
  def select_name(choices)
    choices = choices.map.with_index{ |a, i| [i+1, *a]}
    print_table choices
    selection = ask(set_color("Pick one:",:white)).to_i
    selected = choices[selection-1][1]
    say ""
    return selected #result is an array
  end

  def select_name_and_id(choices)
    choices = choices.map.with_index{ |a, i| [i+1, *a]}
    print_table choices
    selection = ask(set_color("Pick one:",:white)).to_i
    selected = choices[selection-1]
    selected.shift
    say ""
    return selected
  end

  #TODO: refactor to DDD and model objects, separate repository.
  def get_vdc_id_from_org_name(org_name)

    vdc_id = config[:vcloud][:vdcid]
    unless vdc_id
      alert "I need to know which vdc to use . . ."
      org = @connection.get_organization_by_name(org_name)

      selection = select_name_and_id(org[:vdcs])
      error selection

      @vdc_name = selection[0]
      vdc_id = selection[1]
      config[:vcloud][:vdc] = @vdc_name
      config[:vcloud][:vdcid] = vdc_id

      store_org = yes? "Remember this selection? \n(you can override with the `bird setup --vdc <new org>` command\n y\\n? "
      if store_org
        config[:vcloud][:vdc] = @vdc_name
        config[:vcloud][:vdcid] = vdc_id
        config.save
        ok "stored configs for vCloud Org: #{config[:vcloud][:vdcid]}"
      end
    end
    vdc_id
  end

  def get_vapp_id_from_vdc_id(vdc_id)
    vapp_id = config[:vcloud][:vappid]
    unless vapp_id
      alert "I need to know which vapp to use . . ."
      vdc = @connection.get_vdc(vdc_id)

      # if orgs.count then skip the following
      #psuedo : key, value = hash.first

      selection = select_name_and_id(vdc[:vapps])

      @vapp_name = selection[0]
      vapp_id = selection[1]
      config[:vcloud][:vappname] = @vapp_name
      config[:vcloud][:vappid] = vapp_id

      # store_org = yes? "Remember this selection? \n(you can override with the `bird setup --vdc <new org>` command\n y\\n? "
      # if store_org
      #   config[:vcloud][:vdc] = vdc_name
      #   config.save
      #   ok "stored configs for vCloud Org: #{config[:vcloud][:vdc]}"
      # end
    end
    vapp_id
  end

  def get_vm_id_from_vapp_id(vapp_id)

    vm_id = config[:vcloud][:vmid]
    unless vm_id
      alert "I need to know which vm to use . . ."
      vappHash = @connection.get_vapp(vapp_id)
      vapp = Bird::Vapp.new(vappHash)

      selection = select_name_and_id(vapp.vms_hash)

      vm_id = selection[1]
      vm_name = selection[0]
      config[:vcloud][:vm] = vm_name
      config[:vcloud][:vmid] = vm_id
    end
    vm_id
  end

  def action_vm(vm_id, selection=nil)

    vmRaw = @connection.get_vm(vm_id)
    vm = Bird::Vm.new(vmRaw)
    showVmInfo(vm)
    unless selection
      alert "Actions available:"
      choices=['show vm details', 'power-on', 'power-off', 'reboot', 'restore-snapshot', 'take-snapshot']
      choices.delete('power-on') if vm.status == 'running'
      choices.delete('power-off') if vm.status == 'stopped'
      selection = select_name(choices)
    end

    case selection
    when 'power-off'
      taskid = @connection.poweroff_vm(vm_id)
    when 'power-on'
      taskid = @connection.poweron_vm(vm_id)
    when 'reboot'
      taskid = @connection.reboot(vm_id)
    when 'restore-snapshot'
      error "I can't do this for you - functionality is pending..."
    when "take-snapshot"
      error "I can't do this for you - functionality is pending..."
    else
      error "Please report this bug - or make a proper selection!"
    end

    if taskid
      notice("Please wait while I #{selection} your VM . . .")
      task_result = @connection.wait_task_completion(taskid)
      if task_result[:errormsg]
        task_result[:errormsg]
        return
      end
      started = Time.parse(task_result[:start_time])
      ended = Time.parse(task_result[:end_time])
      elapsed_seconds = ended - started

      say("Task completed in #{elapsed_seconds}s.")
      ok(task_result[:status])
    end

  end

  def showVmInfo(vm)
    notice "VM information:"
    say("  name:   #{vm.friendlyName}")
    say("  ips:    #{vm.ips[0]}") if vm.ips.size > 0
    vm.status == 'running'  ? ok("  staus:  #{vm.status}") : error("  staus:  #{vm.status}")
    say ""
  end

  def clear
    run("clear")
    say(set_color(" - bird console - ", :white, :bold))
    say("  vCloud: #{config[:vcloud][:host]}")
    say("    org: #{config[:vcloud][:org]}")
    say("    vdc: #{@vdc_name}") if @vdc_name
    say("    vdc: #{@vapp_name}") if @vapp_name
    say("    vdc: #{@vm_name}") if @vm_name
  end


 password = 'shhhh'
# "shhhh"
 crypted_password = password.encrypt(:symmetric, :password, obfuscation_key)
# "qSg8vOo6QfU=\n"
 crypted_password == 'shhhh'
# true
 password = crypted_password.decrypt
# "shhhh"

  def login
    host = config[:vcloud][:host]
    user = config[:vcloud][:user]
    pass = config[:vcloud][:pass]
    org = config[:vcloud][:org]
    api = "1.5"

    @connection = VCloudClient::Connection.new("https://#{host}", user, pass, org, api)
    say "login to #{config[:vcloud][:host]} . . . "
    @connection.login
    clear
    ObjectSpace.define_finalizer(self, proc { logout })
  end

  def logout
    @connection.logout
  end


  def em(text)
    shell.set_color(text, nil, true)
  end

  def alert(text)
    say(set_color(text, :yellow))
  end

  def notice(text)
    say(set_color(text, :white, :bold))
  end

  def ok(msg=nil)
    text = msg ? "#{msg}" : "OK"
    say "#{msg}\r", :green
  end

  def error(msg)
    say "#{msg}\r", :red
  end

end

