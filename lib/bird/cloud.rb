require 'thor'
require 'thor/actions'
require 'bird'
require 'user_config'
require 'vcloud-rest/connection'
require 'bird/domain/vapp'

class Bird::Cloud < Thor
  include Bird #includes global config.  todo: move to config module?
  include Thor::Actions

  attr_accessor :connection
  attr_accessor :host
  attr_accessor :user
  attr_accessor :org
  attr_accessor :pass
  attr_accessor :api

  default_task :control
  def initialize(*args)
    super
  end
  # Hack to override the help message produced by Thor.
  # With PR $387 this causes unexpected behaviour
  # https://github.com/wycats/thor/issues/261#issuecomment-16880836
  # def self.banner(command, namespace = nil, subcommand = 'list')
  #   "#{basename} list #{command.usage}"
  # end

  desc "vm_snapshot_restore", "shortcut to restore a snapshot by passing in all required parameters", :hide => true
  # option :vm_id, :required => true, :banner => " vm id"
  # option :vorg, :required => true, :banner => " vorg name"
  # option :vuser, :required => true, :banner => " vcloud user name"
  # option :vpass, :required => true, :banner => " encrypted password for vcloud user"
  def vm_snapshot_restore
    # 9619dbf2-7b85-4c78-9384-07995719f920
    #./bird cloud vm_snapshot_restore --vhost vcd011no.lab.vim.dcs.mlb.inet --vorg IDEV7129 --vuser bswift --vpass azBHehbD2EibMuxGZPqIVQ== --vm_id  9619dbf2-7b85-4c78-9384-07995719f920

    # why won't you work!
    # @host = options[:vhost]
    # @org = options[:vorg]
    # @user = options[:vuser]
    # @pass = decrypt(options[:vpass])
    # login
  end

  desc "","",  :hide => true
  def do_vm_snapshot_restore(vm_id)
    ok("doing snapshot restore now!")
    @pass = decrypt(@pass)
    login
    task_id = @connection.revert_vm_snapshot(vm_id)
    wait_for_task(task_id)
  end

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
    login
    org_name = get_organization_name
    vdc_id = get_vdc_id_from_org_name(org_name)
    vapp_id = get_vapp_id_from_vdc_id(vdc_id)
    clear
    #TODO: really need more DDD patterns.  encapsulate everything in controller objects.
    # =>   selecting a vApp will give you two types of commands - actions, and select a vm within.
    vm_id = get_vm_id_from_vapp_id(vapp_id)
    clear
    action_vm(vm_id)
  end

  private

  #TODO: REFACTOR BRANCH:  workflowRefactor
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
      choices=['power-on', 'power-off', 'reboot', 'take snapshot', 'revert snapshot', 'exit']
      choices.delete('power-on') if vm.status == 'running'
      choices.delete('power-off') if vm.status == 'stopped'
      choices.delete('reboot') if vm.status == 'stopped'
      selection = select_name(choices)
    end

    case selection
    when 'power-off'
      taskid = @connection.poweroff_vm(vm_id)
    when 'power-on'
      taskid = @connection.poweron_vm(vm_id)
    when 'reboot'
      taskid = @connection.reboot_vm(vm_id)
    when 'take snapshot'
      taskid = @connection.create_vm_snapshot(vm_id)
    when 'revert snapshot'
      taskid = @connection.revert_vm_snapshot(vm_id)
    when 'exit'
      return
    else
      error "Please report this bug - or make a proper selection!"
    end

    if taskid
      wait_for_task(taskid)
    end

  end

  def wait_for_task(taskid)
    notice("Please wait while I complete your task.")
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

  def showVmInfo(vm)
    notice "VM information:"
    say("  name:   #{vm.friendlyName}")
    say("  ips:    #{vm.ips[0]}") if vm.ips.size > 0
    say("  id:     #{vm.id}") if vm.id
    vm.status == 'running'  ? ok("  staus:  #{vm.status}") : error("  staus:  #{vm.status}")
    say ""
  end

  def clear
    run("clear")
    say(set_color(" - bird console - ", :white, :bold))
    say("  vCloud: #{config[:vcloud][:host]}")
    say("    org: #{config[:vcloud][:org]}")
    say("    vdc: #{@vdc_name}") if @vdc_name
    say("    vapp: #{@vapp_name}") if @vapp_name
  end

  def expect_param_from_config(config_value, cli_param_name)
    warning_string = "config value: '%s' not set.  Supply with:  `bird setup %s {value}`."
    unless config_value
      warning = warning_string % ["#{cli_param_name}", "--#{cli_param_name}"]
      error warning
      raise warning
    end
    config_value
  end

  def load_login_from_config
    @host ||= expect_param_from_config(config[:vcloud][:host], "vhost")
    @user ||= expect_param_from_config(config[:vcloud][:user], "vuser")
    @org ||= expect_param_from_config(config[:vcloud][:org], "vorg")
    @pass ||= decrypt(expect_param_from_config(config[:vcloud][:pass], "vpass"))
    @api = "1.5"
  end

  def login
    load_login_from_config

    @connection = VCloudClient::Connection.new("https://#{@host}", @user, @pass, @org, @api)
    say "login to #{config[:vcloud][:host]} . . . "
    @connection.login

    error("Login failed.")
    alert("To update password run:  `bird setup --vpass <password>`")

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

