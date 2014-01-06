require 'bird'

module Bird
  class VappService
    include Bird

    def initialize(link = nil)
      next_in_chain(link)
    end


    def load_vapp
      puts "#{self.class.to_s}: Loading vApps"
    end

    def vapp_take_snapshot
      puts "#{self.class.to_s}: Taking snapshot of vapp"
    end
    def vapp_restore_snapshot
      puts "#{self.class.to_s}: Restoring snapshot of vapp"
    end
  end
end