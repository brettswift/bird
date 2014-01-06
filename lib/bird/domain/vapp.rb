require 'bird/domain/vm'

module Bird
  class Vapp
    attr_accessor :id
    attr_accessor :name
    attr_accessor :status
    attr_accessor :snapshotDate
    attr_accessor :vms
    attr_reader   :isSummary
    attr_reader   :allocatedIps
    # attr_accessor :vms_hash

    def initialize
      @isSummary = true
      @vms = []
      @allocatedIps = []
    end

    def from_hash(hash)
      isSummary = false
      self.id = hash[:id]
      self.name = hash[:name]
      self.status = hash[:status]
      self.snapshotDate = hash[:vapp_snapshot][:creation_date] if hash[:vapp_snapshot]

      hash[:vms_hash].each { |vmHash|
        vm = Bird::Vm.new.fromVappSummary(vmHash)
        @vms << vm
        @allocatedIps << vm.ips
        # vms_hash.store(vm.friendlyName,vm.id)
      }
      self
    end

    def fromNameAndId(name,id)
      @name = name
      @id = id
      self
      end
    private


  end
end

