# require 'user_config'
# require 'vcloud-rest/connection'
# require 'bird/domain/vorg'
# require 'bird/domain/vdc'
# require 'bird/domain/vapp'
# require 'bird/domain/vm'

# module Bird

#   # CloudService is responsible for interacting with the vCloud API
#   # It extends Thor, so that it can interact with the user, but no methods in here
#   # should be directly exposed to the command line.
#   #
#   # Objects will not be cached here, only connection parameters.
#   # Public methods here should primarily return domain objects where it can.
#   class CloudService <ThorBase
#     include Bird #includes global config and methods.
 

#     desc "","", :hide => true
#     def do_vm_snapshot_restore(vm_id)
#       task_id = @connection.revert_vm_snapshot(vm_id)
#       wait_for_task(task_id)
#     end

#     desc "","", :hide => true
#     def get_organizations
#       orgs = @connection.get_organizations
#       # TODO: return array of organizations
#     end

#     desc "","", :hide => true
#     def get_vdc_from_org_name(org_name = nil, vdc_id = nil)

#       unless vdc_id
#         raise "vCloud organization name, or vDC ID is required to retrieve a vDC" unless org_name

#         alert "I need to know which vdc to use . . ."
#         org = @connection.get_organization_by_name(org_name)

#         selection = select_name_and_id(org[:vdcs])
#         error selection

#         @vdc_name = selection[0]
#         vdc_id = selection[1]
#         config[:vcloud][:vdc] = @vdc_name
#         config[:vcloud][:vdcid] = vdc_id

#         store_org = yes? "Remember this selection? \n(you can override with the `bird setup --vdc <new org>` command\n y\\n? "
#         if store_org
#           config[:vcloud][:vdc] = @vdc_name
#           config[:vcloud][:vdcid] = vdc_id
#           config.save
#           ok "stored configs for vCloud Org: #{config[:vcloud][:vdcid]}"
#         end
#       end
#       vdc_id
#     end

#     private

#     ##### shit not refactored yet #######

#     #TODO: refactor to DDD and model objects, separate repository.
#     def get_vdc_id_from_org_name(org_name)

#       vdc_id = config[:vcloud][:vdcid]
#       unless vdc_id
#         alert "I need to know which vdc to use . . ."
#         org = @connection.get_organization_by_name(org_name)

#         selection = select_name_and_id(org[:vdcs])
#         error selection

#         @vdc_name = selection[0]
#         vdc_id = selection[1]
#         config[:vcloud][:vdc] = @vdc_name
#         config[:vcloud][:vdcid] = vdc_id

#         store_org = yes? "Remember this selection? \n(you can override with the `bird setup --vdc <new org>` command\n y\\n? "
#         if store_org
#           config[:vcloud][:vdc] = @vdc_name
#           config[:vcloud][:vdcid] = vdc_id
#           config.save
#           ok "stored configs for vCloud Org: #{config[:vcloud][:vdcid]}"
#         end
#       end
#       vdc_id
#     end

#     def get_vapp_id_from_vdc_id(vdc_id)
#       vapp_id = config[:vcloud][:vappid]
#       unless vapp_id
#         alert "I need to know which vapp to use . . ."
#         vdc = @connection.get_vdc(vdc_id)

#         # if orgs.count then skip the following
#         #psuedo : key, value = hash.first

#         selection = select_name_and_id(vdc[:vapps])

#         @vapp_name = selection[0]
#         vapp_id = selection[1]
#         config[:vcloud][:vappname] = @vapp_name
#         config[:vcloud][:vappid] = vapp_id

#         # store_org = yes? "Remember this selection? \n(you can override with the `bird setup --vdc <new org>` command\n y\\n? "
#         # if store_org
#         #   config[:vcloud][:vdc] = vdc_name
#         #   config.save
#         #   ok "stored configs for vCloud Org: #{config[:vcloud][:vdc]}"
#         # end
#       end
#       vapp_id
#     end

#     def get_vm_id_from_vapp_id(vapp_id)

#       vm_id = config[:vcloud][:vmid]
#       unless vm_id
#         alert "I need to know which vm to use . . ."
#         vappHash = @connection.get_vapp(vapp_id)
#         vapp = Bird::Vapp.new(vappHash)

#         selection = select_name_and_id(vapp.vms_hash)

#         vm_id = selection[1]
#         vm_name = selection[0]
#         config[:vcloud][:vm] = vm_name
#         config[:vcloud][:vmid] = vm_id
#       end
#       vm_id
#     end

 
#     def clear
#       run("clear")
#       say(set_color(" - bird console - ", :white, :bold))
#       say("  vCloud: #{config[:vcloud][:host]}")
#       say("    org: #{config[:vcloud][:org]}")
#       say("    vdc: #{@vdc_name}") if @vdc_name
#       say("    vapp: #{@vapp_name}") if @vapp_name
#     end


#   end
# end
