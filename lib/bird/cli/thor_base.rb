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


    # TODO: make selection return if only one option exists
    #psuedo : key, value = hash.first
    def select_name(choices)
      choices = choices.map.with_index{ |a, i| [i+1, *a]}
      print_table choices
      selection = ask(set_color("Pick one:",:white)).to_i
      selected = choices[selection-1][1]
      say ""
      return selected #result is an array
    end

    def select_object_from_array(objects)
      choices = Hash[objects.map.with_index { |c,i| [i, c.name] }]
      print_table choices
      selection = ask(set_color("Pick one:",:white)).to_i
      selected_name = choices[selection]
      objects.each do |c| 
         return c if c.name == selected_name
      end
      raise "Please report this error.  I should have found your object in select_id_from_object"
    end

    def print_array(array)
      array.each{|x|
        say(x)
      }
    end

  end
end