require 'user_config'
require 'bird'
require 'symmetric-encryption'

module Bird
	class Configuration
		attr_accessor :host
		attr_accessor :org_name
		attr_accessor :user
		attr_accessor :pass_encrypted
		attr_accessor :curr_vapp_id
		attr_accessor :curr_vm_id
		attr_accessor :isConsoleMode

		def initialize(isConsoleMode = false)
			@isConsoleMode = isConsoleMode
			lazy_load_from_disk unless isConsoleMode
		end
 
		def pass
			decrypt(pass_encrypted)
		end

		def pass=(password)
			@pass_encrypted = encrypt(password)
		end
 
		def save
			raise(Exception, "Save operation not permitted in console mode.") if isConsoleMode
			@config[:vcloud][:host] = @host if @host
			@config[:vcloud][:org_name] = @org_name if @org_name
			@config[:vcloud][:user] = @user if @user
			@config[:vcloud][:pass_encrypted] = @pass if @pass_encrypted
			@config[:vcloud][:curr_vapp_id] = @curr_vapp_id if @curr_vapp_id
			@config[:vcloud][:curr_vm_id] = @curr_vm_id if @curr_vm_id
			@config.save
		end

		def has_minimal_configuration?
			result = true
			result = false unless @host
			result = false unless @org_name
			result = false unless @user
			result = false unless @pass_encrypted
			result
		end

		private

		def lazy_load_from_disk
			@config ||= UserConfig.new('.bird')['conf.yaml']

			unless @config[:vcloud]
				@config[:vcloud] = {}
				@config.save
			end
			@host ||= @config[:vcloud][:host] if @config[:vcloud][:host]
			@org_name ||= @config[:vcloud][:org_name] if @config[:vcloud][:org_name]
			@user ||= @config[:vcloud][:user] if @config[:vcloud][:user]
			@pass_encrypted ||= @config[:vcloud][:pass_encrypted] if @config[:vcloud][:pass_encrypted]
			@curr_vapp_id ||= @config[:vcloud][:curr_vapp_id] if @config[:vcloud][:curr_vapp_id]
			@curr_vapp_id ||= @config[:vcloud][:curr_vm_id] if @config[:vcloud][:curr_vm_id]
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


	end
end
