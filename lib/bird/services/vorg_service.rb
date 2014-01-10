require 'bird'
require 'bird/services/vcloud_connection'
require 'bird/domain/vorg'

module Bird
  class VorgService <ThorBase
    include Bird

    def initialize(link = nil)
      next_in_chain(link)
    end
    
    desc "","", :hide => true
    def get_vorg(org_name)
      raise "Can't get vorg with empty paramater: org_name" unless org_name
      orgRaw = self.vconnection.get_organization_by_name(org_name)
      org = Bird::Vorg.new(org_name).from_hash(orgRaw)
    end
  end
end