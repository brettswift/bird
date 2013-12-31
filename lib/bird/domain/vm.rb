module Bird
  class Vm
    attr_accessor :id
    attr_accessor :name
    attr_accessor :ips
    attr_accessor :status

    def initialize(array)
      self.ips = []
      to_object(array)
    end

    
    private
    def to_object(array)
      self.name = array[0]
      vmInfo = array[1]
      self.id = vmInfo[:id]
      self.status = vmInfo[:status]

        vmInfo[:addresses].each { |ip|
        self.ips << ip
      }
    end

  end
end

