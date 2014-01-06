require 'bird'

module Bird
  class VorgService
    include Bird

    def initialize(link = nil)
      next_in_chain(link)
    end
 
  end
end