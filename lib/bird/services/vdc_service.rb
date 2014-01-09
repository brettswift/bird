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

    desc "","", :hide => true
    def get_allocated_ips(vdc)
      raise "expected Bird::Vdc, found: #{vdc.class.name}" unless vdc.instance_of? Bird::Vdc
      allocated_ips = []
      #vapps are only summaries at this point, need to flesh them to full objects
      if vdc
        vdc.vapps.each{|vapp|
          vapp = chain.get_vapp(vapp.id) if vapp.isSummary
          allocated_ips << vapp.allocatedIps.flatten
        }
      end
      say allocated_ips
      say "0-------"
      #TODO: list these with their vm name. 
      # allocated_ips = allocated_ips.flatten
      # allocated_ips.reject! { |c| c == nil }
      # allocated_ips.sort!
      return allocated_ips
    end



    private



  end
end