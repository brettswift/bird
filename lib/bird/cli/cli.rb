require 'rubygems'
require 'bundler/setup'
require 'thor'
require 'bird'
require 'user_config'
require 'bird/cli/cloud'
require 'bird/cli/setup'
require 'bird/cli/thor_base'

module Bird
  class CLI < ThorBase
    include Bird #includes global config.  todo: move to config module?
    # register(Bird::Cloud, :cloud, "cloud", "interactive cloud control")
    desc "setup ", "used to override setup properties"
    subcommand "setup", Bird::Setup
    
    desc "cloud ", "interactive cloud control"
    subcommand "cloud", Bird::Cloud

    # def self.exit_on_failure?
    #     true
    # end
    
    desc "test", "tests some stuff", :hide => true
    # option :vhost, :required => true, :banner => " vcloud host"
    def test
      Bird.dostuff
      ok "running main"
    end

    desc "crypt", "encrypts a password and spits it out - useful when requiring a script to call this\n\r"
    option :val, :required => true, :banner => " value to encrypt"
    def crypt
        val = options['val']
        encrypted = encrypt(val)
        say "decrypted value:"
        ok " #{encrypted}"
    end
  end
end