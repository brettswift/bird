
module Bird
  class Vm
    attr_accessor :id
    attr_accessor :name
    attr_accessor :machineName
    attr_accessor :ips
    attr_accessor :status
    attr_reader   :isSummary

    def initialize()
      @isSummary = true
      @ips = []
    end

    def from_app_summary(array)

      @name = array[0]
      vmInfo = array[1]
      @id = vmInfo[:id]
      @status = vmInfo[:status]

      vmInfo[:addresses].each { |ip|
        @ips << ip
      }
      self
    end

    def from_hash(vm)
      @isSummary = false
      @id = vm[:id]
      @name = vm[:vm_name]
      @machineName = vm[:guest_customizations][:computer_name]
      @status = vm[:status]
      @ips << vm[:networks][:ip]
      self
    end

  end
end

