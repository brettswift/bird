require 'rubygems'
require 'bundler/setup'
require 'thor'
require 'bird'
require 'user_config'
require 'bird/cli/cloud'
require 'bird/cli/puppet'
require 'bird/cli/thor_base'

module Bird
  class CLI < ThorBase
    include Bird #includes global config.  todo: move to config module?
    register(Bird::Cloud, :cloud, "cloud", "interactive cloud control")
    register(Bird::Puppet, :puppet, "puppet", "kick puppet")

    desc "test", "tests some stuff"
    # option :vhost, :required => true, :banner => " vcloud host"
    def test
      Bird.dostuff
      ok "running main"
    end

    desc "conf", "stores config, interactively if no options sent"
    def conf

    end

    desc "ips","here becuase subcommands don't work"
    def cloud(subcommand: nil)
      if(subcommand == 'ips')
        Bird::Cloud.new.ips
      else
        Bird::Cloud.new.control
      end   
    end

  end
end