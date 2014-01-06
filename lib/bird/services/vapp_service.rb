require 'bird'
require 'bird/services/vcloud_connection'
require 'bird/domain/vapp'

module Bird
  class VappService <ThorBase
    include Bird

    def initialize(link = nil)
      next_in_chain(link)
    end

    desc "","", :hide => true
    def get_vapp(vapp_id)
      vapp_raw = self.vconnection.get_vapp(vapp_id)
      vapp = Bird::Vapp.new.from_hash(vapp_raw)
      return vapp
    end

    # def vapp_take_snapshot
    #   puts "#{self.class.to_s}: Taking snapshot of vapp"
    # end
    # def vapp_restore_snapshot
    #   puts "#{self.class.to_s}: Restoring snapshot of vapp"
    # end
  end
end