require 'bird'
require 'bird/cli/thor_base'
require 'bird/config/configuration'


module Bird
  class Setup < ThorBase
 
    desc "override", "overrides or creates values for stored configuration"
    option :hostname,       :required => false, :aliases => '-n', :banner => "vcloud host"
    option :org_name,       :required => false, :aliases => '-o',  :banner => "vcloud organization name"
    option :user,           :required => false, :aliases => '-u', :banner => "vcloud user"
    option :passEncrypted,  :required => false, :banner => "  !!!BUG!!!: use underscore, not dash /BUG  vcloud password (encrypted) overrides pass"
    option :pass,           :required => false, :banner => "vcloud password (plain text) overridden by pass_encrypted"
    def override
      config = Bird::Configuration.new
      config.host = options[:hostname] if options[:hostname]
      config.org_name = options[:org_name] if options[:org_name]
      config.user = options[:user] if options[:user]
      config.pass_encrypted = options[:pass_encrypted] if options[:pass_encrypted]
      config.pass = options[:pass] if options[:pass]
      config.save
    end

  end
end