require 'bird/domain/vdc'

module Bird
  class Vorg
    attr_accessor :id
    attr_accessor :name
    attr_accessor :vdcs

    #TODO: i don't like this constructor - come back to it 
    def initialize()
      self.vdcs = []
    end

    def fromHash(hash)

    end

    private


  end
end

