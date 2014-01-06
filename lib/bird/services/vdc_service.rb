require 'bird'
require 'bird/services/vcloud_connection'
require 'bird/domain/vdc'
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

      if vdc_id
        vdcRaw = self.vconnection.get_vdc(vdc_id)
        vdc = Bird::Vdc.new.from_hash(vdcRaw)
        return vdc
      end

      raise "not implemented:  get_vdc by org_name"
    end

    private


  end
end