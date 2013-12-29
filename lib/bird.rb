require "bird/version"
require "bird/cli"
require 'user_config'

module Bird
  # share config across module
  def config
    Bird.config
  end

  def self.config
    @config ||= UserConfig.new('.bird')['conf.yaml']
  end
end
