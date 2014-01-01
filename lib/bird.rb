require "bird/version"
require "bird/cli"
require 'user_config'
require 'symmetric-encryption'

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

  private

  # def cipher
  #   Bird.cipher
  # end

  # def self.cipher
  #   @cipher ||= Gibberish::AES.new("p4ssw0rd")
  # end



end
