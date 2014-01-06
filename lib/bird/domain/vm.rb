
module Bird
  class Vm
    attr_accessor :id
    attr_accessor :friendlyName
    attr_accessor :machineName
    attr_accessor :ips
    attr_accessor :status
    attr_reader   :isSummary

    def initialize()
      @isSummary = true
      @ips = []
    end

    def fromVappSummary(array)

      @friendlyName = array[0]
      vmInfo = array[1]
      @id = vmInfo[:id]
      @status = vmInfo[:status]

      vmInfo[:addresses].each { |ip|
        @ips << ip
      }
      self
    end

    def fromFullHash(vm)
      @isSummary = false
      @id = vm[:id]
      @friendlyName = vm[:vm_name]
      @machineName = vm[:guest_customizations][:computer_name]
      @status = vm[:status]
      @ips << vm[:networks][:ip]
      self
    end

  end
end

