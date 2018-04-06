require_relative 'task_container.rb'
require_relative '../utils/utils.rb'
class Task
    
    def initialize(id, desc, date=nil, group="")
        @desc = desc
        @date = date unless date.nil?
        @group = group
        @id = id
        @completed = false
        @archived = false
    end

    def id
        @id
    end

    def desc
        @desc
    end

    def group
        @group
    end

    def date
        @date
    end

    def complete
	    @completed = true
        self
    end 

    def completed?
        @completed
    end

    def <=>(other)
        return -1 if other.completed? && !@completed
        return 1 if @completed && !other.completed?
        if @date.is_a?(Date) && other.date.is_a?(Date)
            order = @date <=> other.date
            return order unless order == 0
            return @id <=> other.id
        elsif (@date.nil? && other.date.nil?)
            return @id <=> other.id
        end
        return -1 if @date.nil?
        return 1
    end

    def archived?
	    @archived
    end

    def archive_if_completed
    	@archived = @archived || @completed
    end

    def to_s(show_group = true)
        s = "#{@id}\t"
        s += "[#{@completed ? "X" : " "}]\t"
        s += "#{Utils.human_date(@date)}\t" unless @date.nil?
        s += "\t" if @date.nil?
        s += @group.empty? ?  "" : "#{@group} " if show_group
        s += @desc
    end
end
