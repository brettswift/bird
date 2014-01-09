
module Bird
  class Ip
    attr_accessor :ip
    attr_accessor :name
    attr_accessor :machineName

    def initialize(ip,name,machineName = nil)
      @ip = ip
      @name = name
      @machineName = machineName
    end
  end
end

