require 'thor'
require 'thor/actions'
require 'user_config'
require 'vcloud-rest/connection'
require 'bird'
require 'bird/cli/thor_base'
require 'bird/domain/vapp'
require 'bird/domain/vm'
require 'bird/domain/vdc'
require 'bird/domain/vorg'
require 'bird/services/vcloud_connection'
require 'bird/services/vorg_service'
require 'bird/services/vdc_service'
require 'bird/services/vapp_service'
require 'bird/services/vm_service'

module Bird
    class Cloud < ThorBase
        include Bird #includes global config.  todo: move to config module?

        attr_accessor :host
        attr_accessor :org_name
        attr_accessor :user
        attr_accessor :pass

        attr_accessor :curr_vdc
        attr_accessor :curr_vapp
        attr_accessor :curr_vm


        #BUG: default task control causes subcommands to fail
        # default_task :control

        # def initialize(*args)
        #     @org_name = config[:vcloud][:org]
        #     super
        # end

        desc "control","does a lot of stuff for you "
        def control
            return unless validate_required_login_params

            load_vdc
            reset_header
            vapp_summary = select_object_from_array(@curr_vdc.vapps)

            @curr_vapp = chain.get_vapp(vapp_summary.id)
            reset_header

            vm_summary = select_object_from_array(@curr_vapp.vms)

            @curr_vm = chain.get_vm(vm_summary.id)
            reset_header

            action_vm(@curr_vm.id)

        end


        desc "ips","list ips of machines that have been allocated"
        def ips
            load_vdc
            @curr_vdc = chain.get_vdc(vdc_id: @curr_vdc.id)
            ips = chain.get_allocated_ips(@curr_vdc)
            print_ips ips
        end

        desc "revertvm", "shortcut for a one line command to restore a snapshot of a VM"
        option :vhost, :required => true, :banner => "{vcloud host name}"
        option :vorg_name, :required => true, :banner => "{vcloud organization name}"
        option :vuser, :required => true, :banner => "{vcloud user id}"
        option :vpass, :required => true, :banner => "{vcloud password (encrypted)}"
        option :vmid, :required => true, :banner => "{vcloud vm id}"
        def revertvm
            @host = options['vhost']
            @user = options['vuser']
            @pass = options['vpass']
            @org_name = options['vorg_name']
            vmid = options['vmid']

            update_config(@host,@org_name,@user,@pass)

            ok "restoring snapshot"
            @curr_vm = chain.get_vm(vmid)
            action_vm(@curr_vm.id, "revert snapshot")
        end

        private

        def update_config(host,org_name,user,pass)
            config[:vcloud] = {}
            config[:vcloud][:host] = host
            config[:vcloud][:org] = org_name
            config[:vcloud][:user] = user
            config[:vcloud][:pass] = pass
            config.save
        end

        def validate_required_login_params
            result = true
            result = false unless config[:vcloud]
            if config[:vcloud]
                @host = config[:vcloud][:host] if config[:vcloud][:host]
                result = false unless @host
                
                @org_name ||= config[:vcloud][:org] if config[:vcloud][:org]
                result = false unless @org_name
                
                @user ||= config[:vcloud][:user] if config[:vcloud][:user]
                result = false unless @user
                
                @pass ||= config[:vcloud][:pass] if config[:vcloud][:pass]
                result = false unless @pass
            end
            #TODO: implement `bird help setup`
            error("Please configure bird first. See: `bird help setup`") unless result
            return result
        end

        def print_ips(ips)
            ips.each{|ip|
                say("#{ip.ip}  - #{ip.name}")
            }
        end


        def load_vdc
            unless @curr_vdc
                vorg = chain.get_vorg(@org_name)
                if vorg.vdcs.size == 1
                    @curr_vdc = vorg.vdcs[0]
                end
            end
            @curr_vdc = chain.get_vdc(vdc_id: @curr_vdc.id)
        end

        def showVmInfo(vm)
            notice "VM information:"
            say("  name:   #{vm.name}")
            vm.ips.each {|ip|
                say("  ip:     #{ip}")
            }

            say("  id:     #{vm.id}") if vm.id
            vm.status == 'running'  ? ok("  staus:  #{vm.status}") : error("  staus:  #{vm.status}")
            say ""
        end

        def reset_header
            run("clear")
            say(set_color(" - bird console - ", :white, :bold))
            say("  vCloud: #{@host}")
            say("     org: #{@org_name}")
            say("     vdc: #{@curr_vdc.name}") if @curr_vdc
            say("    vapp: #{@curr_vapp.name}") if @curr_vapp
            # say("    vm: #{@curr_vm.name}") if @curr_vm
            say(" - - - - - - - - - - - - - - - - - - - -")
        end

        def action_vm(vm_id, selection=nil)
            # vmRaw = @connection.get_vm(vm_id)
            # vm = Bird::Vm.new(vmRaw)
            vm = @curr_vm
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
                chain.poweroff_vm(vm_id)
            when 'power-on'
                chain.poweron_vm(vm_id)
            when 'reboot'
                chain.reboot_vm(vm_id)
            when 'take snapshot'
                chain.create_vm_snapshot(vm_id)
            when 'revert snapshot'
                chain.revert_vm_snapshot(vm_id)
            when 'exit'
                return
            else
                error "Please report this bug - or make a proper selection!"
            end

        end

    end
end