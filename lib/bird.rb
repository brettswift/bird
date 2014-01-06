require "bird/version"
require "bird/cli/cli"
require 'user_config'
require 'symmetric-encryption'
require 'bird/services/vm_service'
require 'bird/services/vapp_service'
require 'bird/services/vdc_service'
require 'bird/services/vorg_service'


module Bird
  # share config across module
  def config
    Bird.config
  end

  def self.config
    @config ||= UserConfig.new('.bird')['conf.yaml']
  end

  def encrypt(text)
    SymmetricEncryption.cipher = SymmetricEncryption::Cipher.new(
    :key         => '1234567890ABCDEF1234567890ABCDEF',
    :iv          => '1234567890ABCDEF',
    :cipher_name => 'aes-128-cbc'
    )

    SymmetricEncryption.encrypt(text)
  end

  def decrypt(encryptedText)
    SymmetricEncryption.cipher = SymmetricEncryption::Cipher.new(
    :key         => '1234567890ABCDEF1234567890ABCDEF',
    :iv          => '1234567890ABCDEF',
    :cipher_name => 'aes-128-cbc'
    )

    SymmetricEncryption.decrypt(encryptedText)
  end


  def next_in_chain(link)
    @next = link
  end

  def method_missing(method, *args, &block)
    if @next == nil
      puts "This request cannot be handled! #{method}"
      return
    end
    @next.__send__(method, *args, &block)
  end

  def self.dostuff
    chain.vm_power_on
    chain.vdc_list_vapps
  end

  def chain
    Bird.chain
  end

  def self.chain
    #chain to run most specific first
    @chain ||= Bird::VmService.new(Bird::VappService.new(Bird::VdcService.new(Bird::VorgService.new)))
  end


end
