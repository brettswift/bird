require 'rubygems'
require 'bundler/setup'
require 'thor'
require 'bird'
require 'user_config'
require 'bird/cloud.rb'

class Bird::CLI < Thor
  include Bird #includes global config.  todo: move to config module?

  register(Bird::Cloud, :cloud, "cloud [help] [list,snapshot,restore,deploy]", " control your cloud!")

  desc "setup", "setup configuration variables"
  long_desc <<-LONGDESC
        Configures vCloud and Puppet hosts and credentials. 

        Example usage:
        \x5`bird setup`:  will take you through an interactive setup of all required parameters. 

        `bird setup --vhost  vcloud.host.net --vuser jbond`: will set the two properties, and query any that are missing. 

        `bird setup --showconfig` or `bird setup -s`:  outputs current configuration settings.

        Further Help:
        \x5 `bird help cloud`  for a description of how to interact with your VMs. 

      LONGDESC
      option :vhost, :aliases => :vh, :banner => " vcloud host (omit http)"
      option :vuser, :aliases => :vu, :banner => " vcloud api user"
      option :vpass, :aliases => :vp, :banner => " vcloud password"
      option :vorg, :aliases => :vo, :banner => " vcloud organization"
      option :phost, :aliases => :ph, :banner => " puppet host (omit http)"
      option :puser, :aliases => :pu, :banner => " puppet ssh user"
      option :ppass, :aliases => :pp, :banner => " puppet password"
      option :showconfig, :aliases => :s, :banner => " shows configuration already saved (supercedes all other commands)"
      def setup
        if options[:showconfig]
          show_config
          return
        end

        #command params should override current config
        config[:vcloud][:host] = options[:vhost] if options[:vhost]
        config[:vcloud][:host] = options[:vuser] if options[:vuser]
        config[:vcloud][:host] = options[:vpass] if options[:vpass]
        config[:vcloud][:org]  = options[:vorg]  if options[:vorg] 
        config[:puppet][:host] = options[:phost] if options[:phost]
        config[:puppet][:host] = options[:puser] if options[:puser]
        config[:puppet][:host] = options[:ppass] if options[:ppass]

        check_setup
        config.save
      end

      private
      def show_config
        config.each do |key, val|
          say "#{key}: #{val}"
        end
      end

      def check_setup
        if config_nil? then
          setup_from_scratch
        else
          say "I'm fully configured, lets go... ",  :green
          say "Configuration used:"
          show_config
          say "\r\n"
        end
      end

      def config_nil?
        false
        config[:vcloud]={} unless config[:vcloud]
        config[:puppet]={} unless config[:puppet]

        true unless config[:vcloud][:host]
        true unless config[:vcloud][:user]
        true unless config[:vcloud][:pass]
        # true unless config[:vcloud][:org]
        true unless config[:puppet][:host]
        true unless config[:puppet][:user]
        true unless config[:puppet][:pass]
      end

      def setup_from_scratch #TODO: clean this up - too much copy/paste
        say "I'm missing some configuration entries. Let's sort that out first....", :yellow
        #vCloud config
        unless config[:vcloud][:host]
          host = ask("Enter vcloud Host: (omit http:\\\\): \r\n")
          config[:vcloud][:host] = host
          say "Host set to: #{host}", :green
        end
        unless config[:vcloud][:org]
          org = ask("Enter vcloud organization (ex: IDEV7129: \r\n")
          config[:vcloud][:org] = org
          say "using: #{org}\n", :green
        end
        unless config[:vcloud][:user]
          user = ask("Enter vcloud login user: \r\n")
          config[:vcloud][:user] = user
          say "using: #{user}", :green
        end
        unless config[:vcloud][:pass]
          pass = ask("Enter vcloud pass: \r\n")
          config[:vcloud][:pass] = pass
          say "using: shhh it's a secret\n"
        end

        #puppet config
        unless config[:puppet][:host]
          host = ask("Enter puppet Host: (omit http:\\\\): \r\n")
          config[:puppet][:host] = host
          say "Host set to: #{host}", :green
        end
        unless config[:puppet][:user]
          user = ask("Enter puppet login user: \r\n")
          config[:puppet][:user] = user
          say "using: #{user}", :green
        end
        unless config[:puppet][:pass]
          pass = ask("Enter puppet pass: \r\n")
          config[:puppet][:pass] = pass
          say "using: shhh it's a secret\n", :green
        end

      end


      def em(text)
        shell.set_color(text, nil, true)
      end

      def ok(detail=nil)
        text = detail ? "OK, #{detail}." : "OK."
        say text, :green
      end

      def error(detail)
        say detail, :red
      end


    end
