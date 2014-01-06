require 'thor'
require 'thor/actions'
require 'bird'

module Bird
  class ThorBase < Thor
    include Thor::Actions


    protected
    def em(text)
      shell.set_color(text, nil, true)
    end

    def alert(text)
      say(set_color(text, :yellow))
    end

    def notice(text)
      say(set_color(text, :white, :bold))
    end

    def ok(msg=nil)
      text = msg ? "#{msg}" : "OK"
      say "#{msg}\r", :green
    end

    def error(msg)
      say "#{msg}\r", :red
    end
  end
end