require 'bird'

module Bird
  class VmService
    include Bird

    def initialize(link = nil)
      next_in_chain(link)
    end

    def vm_power_on
      # unless selected_vapp
        chain.load_vapp

      # end

      puts "#{self.class.to_s}: Powering on the vm"
    end
  end
end
