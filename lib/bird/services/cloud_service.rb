require 'user_config'
require 'vcloud-rest/connection'
require 'bird/domain/vorg'
require 'bird/domain/vdc'
require 'bird/domain/vapp'
require 'bird/domain/vm'

module Bird

  # CloudService is responsible for interacting with the vCloud API
  # It extends Thor, so that it can interact with the user, but no methods in here
  # should be directly exposed to the command line.
  #
  # Objects will not be cached here, only connection parameters.
  # Public methods here should primarily return domain objects where it can.
  class CloudService <ThorBase
    include Bird #includes global config and methods.

    attr_accessor :connection
    attr_accessor :host
    attr_accessor :user
    attr_accessor :pass
    attr_accessor :org_name
    attr_reader :api

    def initialize()
      login
    end

    desc "","", :hide => true
    def do_vm_snapshot_restore(vm_id)
      task_id = @connection.revert_vm_snapshot(vm_id)
      wait_for_task(task_id)
    end

    desc "","", :hide => true
    def get_organizations
      orgs = @connection.get_organizations
      # TODO: return array of organizations
    end

    desc "","", :hide => true
    def get_vdc_from_org_name(org_name = nil, vdc_id = nil)

      unless vdc_id
        raise "vCloud organization name, or vDC ID is required to retrieve a vDC" unless org_name

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

    private

    def load_config
      @host ||= expect_param_from_config(config[:vcloud][:host], "vhost")
      @user ||= expect_param_from_config(config[:vcloud][:user], "vuser")
      @org_name ||= expect_param_from_config(config[:vcloud][:org], "vorg")
      @pass ||= decrypt(expect_param_from_config(config[:vcloud][:pass], "vpass"))
      @api = "1.5"
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

    def login
      load_config

      @connection ||= VCloudClient::Connection.new("https://#{@host}", @user, @pass, @org_name, @api)
      @connection.login

      # TODO: handle in cli:   error("Login failed.")
      # TODO: handle in cli:   alert("To update password run:  `bird setup --vpass <password>`")

      # TODO: handle in cli:   clear
      ObjectSpace.define_finalizer(self, proc { logout })
    end

    def validate_required(variable, varname)
      raise "#{varname} is required to log in.  Set with: `bird setup --#{varname} <value>" unless variable
    end

    def logout
      @connection.logout
    end

    ##### shit not refactored yet #######


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


    # def login
    #   # load_login_from_config

    #   @connection = VCloudClient::Connection.new("https://#{@host}", @user, @pass, @org, @api)
    #   say "login to #{config[:vcloud][:host]} . . . "
    #   @connection.login

    #   error("Login failed.")
    #   alert("To update password run:  `bird setup --vpass <password>`")

    #   clear
    #   ObjectSpace.define_finalizer(self, proc { logout })
    # end

    # def logout
    #   @connection.logout
    # end


  end
end
