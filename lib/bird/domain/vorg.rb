require 'bird/domain/vdc'

module Bird
  class Vorg
    attr_accessor :id
    attr_accessor :name
    attr_accessor :vdcs

    def initialize(name)
      @name = name
      self.vdcs = []
    end

    def from_id_name(id,name)
      @id = id
      @name = name
      self.vdcs = []
    end

    def from_hash(hash)
      hash[:vdcs].each {|vdcItem|
        vdc = Bird::Vdc.new
        vdc.id = vdcItem[1]
        vdc.name = vdcItem[0]
        @vdcs << vdc
      }
      self
    end

    private


  end
end

