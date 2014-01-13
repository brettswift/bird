require 'bird'
require 'bird/cli/thor_base'
require 'bird/config/configuration'


module Bird
  class Setup < ThorBase

    # desc "setup", "setup stuff"
    # option :setup, :required => false, :banner => " help"
    # def help(command, options={:default => nil})
    #   ok "here is setup "
    # end

    desc "override", "overrides or creates values for stored configuration"
    option :host, :required => false, :banner => "vcloud host"
    option :org_name, :required => false, :banner => "vcloud organization name"
    option :user, :required => false, :banner => "vcloud user"
    option :pass_encrypted, :required => false, :banner => "vcloud password (encrypted) overrides pass"
    option :pass, :required => false, :banner => "vcloud password (plain text) overridden by pass_encrypted"
    def override
      config = Bird::Configuration.new
      config.host = options[:host] if options[:host]
      config.org_name = options[:org_name] if options[:org_name]
      config.user = options[:user] if options[:user]
      config.pass_encrypted = options[:pass] if options[:pass_encrypted]
      config.pass = options[:pass] if options[:pass]
      config.save
    end

  end
end