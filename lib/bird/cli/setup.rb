require 'bird'
require 'bird/cli/thor_base'
require 'bird/config/configuration'


module Bird
  class Setup < ThorBase
  
    default_task :guideme

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

    desc "guideme", "{default} - guides you through missing configuration"
    def guideme
      config = Bird::Configuration.new

      notice("Answer the following questions, or hit enter to skip")

      host = ask("Enter your vcloud host name (tip: no http://): ")
      if host != ""
        config.host = host
      end

      org = ask("Enter your organization: ")
      if org != ""
        config.org_name = org
      end

      user = ask("Enter your user: ")
      if user != ""
        config.user = user
      end

      pass = ask("Enter your password: ", :echo => false)
      if pass != ""
        config.pass = pass
      end

      config.save

      notice("\r\nSetup complete.\r\n")

    end

    desc "show", "shows current configuration"
    def show
      notice("Configuration:")
      say "Hostname:            #{config.host}"
      say "Organization:        #{config.org_name}"
      say "User:                #{config.user}"
      say "Encrypted Password:  #{config.passEncrypted}"
    end


  end
end