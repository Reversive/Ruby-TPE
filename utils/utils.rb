require 'date'
require_relative '../exceptions/invalid_date_exception'
class Utils

    def initialize
        raise 'Unable to instantiate Utils'
    end

    def Utils.parse_input(str)
        response = str.partition(" ")
        response.delete_at(1)
        return response[0], response[1]
    end

    def Utils.parse_date(date)
        today = Date.today
        case date
        when 'tomorrow'
            return today.next_day
        when 'yesterday'
            return today.prev_day
        when 'today'
            return today
        else
            raise InvalidDateException unless Utils.valid_date?(date)
            split_date = date.split('/')
            int_date = split_date.map {|e| e.to_i}
            return Date.new(int_date[2], int_date[1], int_date[0])
        end
    end

    def Utils.this_week
        today = Date.today
        start = today.prev_day(today.wday)
        final = today.next_day(6-today.wday)
        start..final
    end

    def Utils.human_date(date)
        today = Date.today
        if(today === date)
            return 'today'
        elsif (today.next_day === date)
            return 'tomorrow'
        elsif (today.prev_day === date)
            return 'yesterday'
        else
            return date.strftime("%d/%m/%Y")
        end
    end

    def Utils.split_date_description(str)
        parsed_str = str.rpartition(" due ")
        if parsed_str[1].empty?
			due_date = nil
			description = parsed_str.last.strip
		else
			due_date = parsed_str.last.strip
			description = parsed_str[0].strip
        end
        return due_date, description
    end

    def Utils.split_group_description(description)
        parsed_description = description.partition(" ")
        if parsed_description[0][0] == '+'
			group = parsed_description.first
			description = parsed_description.last
		else
            group = ""
			description = parsed_description.first + " " + parsed_description.last
        end
        return group, description
    end


    def Utils.valid_date?(date)
        return true if date_keyword?(date)
        reg = Regexp.new('(^(((0[1-9]|1[0-9]|2[0-8])[\/](0[1-9]|1[012]))|((29|30|31)[\/](0[13578]|1[02]))|((29|30)[\/](0[4,6,9]|11)))[\/](19|[2-9][0-9])\d\d$)|(^29[\/]02[\/](19|[2-9][0-9])(00|04|08|12|16|20|24|28|32|36|40|44|48|52|56|60|64|68|72|76|80|84|88|92|96)$)')
        return true unless date.match(reg).nil?
        return false
    end

    def Utils.date_keyword?(date)
        date == "tomorrow" || date == "today" || date == "yesterday"
    end

    def Utils.is_number?(str)
        rgx = Regexp.new('^[0-9]+$')
        str.match(rgx)
    end

    def Utils.is_alpha?(str)
        rgx = Regexp.new('^[0-9A-Za-z]+$')
        str.match(rgx)
    end

    def Utils.valid_groupname?(str)
        rgx = Regexp.new('^\+[a-zA-Z0-9]+$')
        return true unless str.match(rgx).nil?
        return false
    end 
    def Utils.valid_filename?(str)
        rgx = Regexp.new('^[a-zA-Z][0-9A-Za-z_-]*$')
        str.match(rgx)
    end
end