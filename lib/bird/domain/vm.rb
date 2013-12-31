module Bird
  class Vm
    attr_accessor :id
    attr_accessor :friendlyName
    attr_accessor :machineName
    attr_accessor :ips
    attr_accessor :status

    #TODO: i don't like this constructor - come back to it 
    def initialize(fullVm = nil, vmSummaryArray = nil)
      self.ips = []
      initFromVappSummary(vmSummaryArray) if vmSummaryArray
      to_object(fullVm) if fullVm
    end




    private

    def initFromVappSummary(array)
      self.friendlyName = array[0]
      vmInfo = array[1]
      self.id = vmInfo[:id]
      self.status = vmInfo[:status]

      vmInfo[:addresses].each { |ip|
        self.ips << ip
      }
    end

    def to_object(vm)
      self.id = vm[:id]
      self.friendlyName = vm[:vm_name]
      self.machineName = vm[:guest_customizations][:computer_name]
      self.status = vm[:status]
    end

  end
end

