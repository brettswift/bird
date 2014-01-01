
module Bird
  class Vapp
    attr_accessor :id
    attr_accessor :name
    attr_accessor :vms 
    attr_accessor :vms_hash

    # def initialize()
    # end

    private

    def to_object(hash)
      self.id = hash[:id]

      hash[:vms_hash].each { |vmHash|
        vm = Bird::Vm.new(nil, vmHash)
        vms << vm
        vms_hash.store(vm.friendlyName,vm.id)
      }
    end
  end
end

