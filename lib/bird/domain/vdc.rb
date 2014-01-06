require 'bird/domain/vapp'

module Bird
  class Vdc
    attr_accessor :id
    attr_accessor :name
    attr_accessor :vapps

    def initialize()
      self.vapps = []
    end

    def fromHash(hash)
      @id = hash[:id]
      @name = hash[:name]

      hash[:vapps].each { |vappHash|
        vapp = Bird::Vapp.new.fromNameAndId(vappHash[0], vappHash[1])
        vapps << vapp
      }

      self
    end

    private


  end
end

