require 'thor'
require 'thor/actions'
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

        attr_accessor :curr_vdc
        attr_accessor :curr_vapp
        attr_accessor :curr_vm


        #BUG: default task control causes subcommands to fail
        # default_task :control

        desc "control","does a lot of stuff for you "
        def control
            validate_required_login_params

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
            validate_required_login_params
            load_vdc
            @curr_vdc = chain.get_vdc(vdc_id: @curr_vdc.id)
            ips = chain.get_allocated_ips(@curr_vdc)
            print_ips ips
        end

        ##TODO: move to 'console' command?
        #  ie a location where local config is expected to be skipped?
        desc "revertvm", "shortcut for a one line command to restore a snapshot of a VM"
        option :vhost, :required => true, :banner => "{vcloud host name}"
        option :vorg_name, :required => true, :banner => "{vcloud organization name}"
        option :vuser, :required => true, :banner => "{vcloud user id}"
        option :vpass, :required => true, :banner => "{vcloud password (encrypted)}"
        option :vmid, :required => true, :banner => "{vcloud vm id}"
        def revertvm
            config.isConsoleMode = true
            config.host = options['vhost']
            config.user = options['vuser']
            config.pass = options['vpass']
            config.org_name = options['vorg_name']
            vmid = options['vmid']

            ok "restoring snapshot"
            @curr_vm = chain.get_vm(vmid)
            action_vm(@curr_vm.id, "revert snapshot")
        end

        private

        def validate_required_login_params
            result = true

            unless config.host
                result = false
                error("host name configuration required")
            end
            unless config.org_name
                result = false
                error("organization name configuration required")
            end
            unless config.user
                result = false
                error("user name configuration required")
            end
            unless config.pass
                result = false
                error("password configuration required")
            end
            
            unless result
                error("Please configure bird first. See: `bird help setup`")
                raise "Can not proceed.  Configuration setup is required"
            end
            result
        end

        def print_ips(ips)
            ips.each{|ip|
                say("#{ip.ip}  - #{ip.name}")
            }
        end


        def load_vdc
            unless @curr_vdc
                vorg = chain.get_vorg(config.org_name)
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
            say("  vCloud: #{config.host}")
            say("     org: #{config.org_name}")
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