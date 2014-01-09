require 'bird'
require 'bird/cli/thor_base'

module Bird
  class Puppet < ThorBase

    desc "puppet help", "display puppet help"
    option :help_kick_environment, :required => false, :banner => " help"
    def help(command, options={:default => nil})
      ok "here is puppet help"
    end

    desc "kick_environment", "run `bird puppet help [COMMAND]`"
    def kick_environment
      error "not implemented yet"
    end
  end
end