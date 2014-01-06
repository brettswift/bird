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


        default_task :control
        def initialize(*args)
            @org_name = config[:vcloud][:org]
            super
        end

        desc "control","does a lot of stuff for you "
        def control
            unless @curr_vdc
                vorg = chain.get_vorg(@org_name)
                if vorg.vdcs.size == 1
                    @curr_vdc = vorg.vdcs[0]
                end
            end

            @curr_vdc = chain.get_vdc(vdc_id: @curr_vdc.id)

            vapp_summary = select_object_from_array(@curr_vdc.vapps)

            @curr_vapp = chain.get_vapp(vapp_summary.id)
            
            # vapp_id = get_vapp_id_from_vdc_id(vdc_id)
            # clear
            # #TODO: really need more DDD patterns.  encapsulate everything in controller objects.
            # # =>   selecting a vApp will give you two types of commands - actions, and select a vm within.
            # vm_id = get_vm_id_from_vapp_id(vapp_id)
            # clear
            # action_vm(vm_id)



        end

        private

    end
end