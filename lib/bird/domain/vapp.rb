require 'yaml'
require 'bird/domain/vm'
module Bird
  class Vapp
    attr_accessor :id
    attr_accessor :name
    attr_accessor :vms 
    attr_accessor :vms_hash

    def initialize(hash)
      self.vms = []
      self.vms_hash = {}
      to_object(hash)
    end

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

