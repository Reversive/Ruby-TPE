require_relative '../utils/utils'

class Printer

    def initialize
        raise 'Unable to instantiate Printer'
    end

    def Printer.puts(string)
        STDOUT.puts string
    end

    def Printer.print(string)
        STDOUT.print string
    end

    def Printer.print_list(data, print_groups=true)
        data.each_pair {|group, tasks| 
            puts group unless group.empty?
            tasks.each {|task| puts task.to_s(print_groups)}
        }
    end

    def Printer.print_list_without_group(data)
        Printer.print_list(data, false)
    end
end
