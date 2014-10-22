require 'vcloud-rest/connection'
require 'bird/cli/thor_base'

module Bird
  def vconnection
    Bird.vconnection
  end

  def self.vconnection
    @vconnection ||= VCloudConnectionFactory.new.connection
  end


  class VCloudConnectionFactory <ThorBase
    include Bird #includes global config and methods.

    attr_accessor :connection
    attr_accessor :host
    attr_accessor :user
    attr_accessor :pass
    attr_accessor :org_name
    attr_reader :api

    def initialize()
      login
    end

    private
 
    def expect_param_from_config(config_value, cli_param_name)
      warning_string = "config value: '%s' not set.  Supply with:  `bird setup %s {value}`."
      unless config_value
        warning = warning_string % ["#{cli_param_name}", "--#{cli_param_name}"]
        error warning
        raise warning
      end
      config_value
    end

    def login

      @connection ||= VCloudClient::Connection.new("https://#{config.host}", config.user, config.pass, config.org_name, @api)
      @connection.login

      # TODO: handle in cli:   error("Login failed.")
      # TODO: handle in cli:   alert("To update password run:  `bird setup --vpass <password>`")

      # TODO: handle in cli:   clear
      ObjectSpace.define_finalizer(self, proc { logout })
    end


    def logout
      @connection.logout
    end
  end
end

