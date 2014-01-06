require 'bird'

module Bird
  class VdcService
    include Bird

    def initialize(link = nil)
      next_in_chain(link)
    end

    def vdc_list_vapps
      puts "#{self.class.to_s}: Listing vApps"
    end
  end
end