require 'bird'
require 'bird/services/vcloud_connection'
require 'bird/cli/thor_base'

module Bird
  class VdcService <ThorBase
    include Bird

    def initialize(link = nil)
      next_in_chain(link)
    end

    desc "","", :hide => true
    def vdc_list_vapps
      puts "#{self.class.to_s}: Listing vApps"
    end

    desc "","", :hide => true
    def get_vdc(org_name: nil, vdc_id: nil)

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
    

  end
end