require_relative '../exceptions/invalid_group_exception'
require_relative '../exceptions/completed_task_exception'
require_relative '../exceptions/invalid_task_exception'
require_relative 'task'

class TaskContainer
    
    def initialize
        @tasks = Array.new
        @idx = 0
    end

    def add(description, due_date, group)
        task = Task.new(get_next_id, description, due_date, group)
        @tasks << task
        task
    end

    def tasks
       unarchived_tasks = @tasks.reject {|v| v.archived? }
       unarchived_tasks.sort
    end

    def find_by_id(task_id)
        @tasks.find { |task| task.id == task_id unless task.archived? }
    end

    def grouped_tasks
        tasks.reduce(Hash.new){|hash, task| 
            if task.group != ""  
                groupName = task.group[1..-1]
                hash[groupName] = Array.new if hash[groupName].nil?
                hash[groupName] << task
            end
            hash 
        }
    end

    def tasks_by_group(str)
        groupName = str[1..-1]
        raise InvalidGroupException unless grouped_tasks.has_key?(groupName) 
        ret_hash = Hash.new
        ret_hash[groupName] = grouped_tasks[groupName]
        ret_hash
    end

    def tasks_by_range(range)
        tasks_range = tasks.select { |v| range === v.date }
        { "all" => tasks_range}
    end

    def overdue_tasks
        today = Date.today
        tasks_due = tasks.reject { |v| v.date.nil? || v.date >= today}
        { "all" => tasks_due }
    end

    def tasks_by_date(date)
        tasks_due = tasks.reject { |v| v.date != date}
        { "all" => tasks_due }
    end

    def get_all_tasks
        { "all" => tasks}
    end

    def find(str)
        found_arr = tasks.select {|task| task.desc.downcase.include?(str.downcase) }
        { "" => found_arr}
    end

    def complete_task(id)
        task = find_by_id(id)
        raise InvalidTaskException if task.nil?
        raise CompletedTaskException.new(id) if task.completed?
        task.complete
    end

    def get_next_id
        @idx += 1
        @idx
    end

    def archive_completed
        @tasks.each{|task| task.archive_if_completed}
    end
end
