require 'thor'
require 'thor/actions'
require 'bird'

module Bird
  class ThorBase < Thor
    include Thor::Actions


    desc "","", :hide => true
    def em(text)
      shell.set_color(text, nil, true)
    end

    desc "","", :hide => true
    def alert(text)
      say(set_color(text, :yellow))
    end

    desc "","", :hide => true
    def notice(text)
      say(set_color(text, :white, :bold))
    end

    desc "","", :hide => true
    def ok(msg=nil)
      text = msg ? "#{msg}" : "OK"
      say "#{msg}\r", :green
    end

    desc "","", :hide => true
    def error(msg)
      say "#{msg}\r", :red
    end
  end
end