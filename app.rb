require_relative 'front/input'
require_relative 'front/printer'
require_relative 'app/task_container'

require_relative 'utils/logger'
require_relative 'utils/file_manager'
require_relative 'utils/utils'
require_relative 'exceptions/invalid_date_exception'
require_relative 'exceptions/invalid_task_exception'
require_relative 'exceptions/invalid_group_format_exception'
require_relative 'exceptions/invalid_group_exception'

class App
	@default_date
	@default_group
	def initialize
		@task_container = TaskContainer.new
	end
	def run()
			loop do
				begin
					command = Input.get()
					break if command == "exit"
					execute(command)
				rescue Exception => e
					Logger.log(e)
					Printer.puts(e.message)
				end
			end
	end

	def execute(command)
		command, parameters = Utils.parse_input(command)
		case command
		when "add"
			add(parameters)
		when "list"
			list(parameters)
		when "save"
			save(parameters)
		when "open"
			open(parameters)
		when "complete"
			complete(parameters)
		when "ac"
			ac(parameters)
		when "find"
			find(parameters)
		when "set"
			set(parameters)
		else
			raise InvalidTaskException
		end
	end

	def add(str)
		raise InvalidTaskException if str.empty?
		# Separamos el due_date
		due_date, description = Utils.split_date_description(str)
		if not due_date.nil?
			due_date = Utils.parse_date(due_date)
		else
			due_date = @default_date unless @default_date.nil?
		end

		# Separamos el grupo
		group, description = Utils.split_group_description(description)
		group = @default_group if group.empty? && !@default_group.nil?
		raise InvalidGroupException if group == "+"

		raise InvalidTaskException if description.empty?
		task = @task_container.add(description, due_date, group)
		Printer.puts("Todo [#{task.id}: #{task.desc}] added.")
	end

	def find(str)
		found_hash = @task_container.find(str)
		Printer.print_list(found_hash)
	end

	def list(str)
		groups_hash = Hash.new
		case str
		when ""
			tasks = @task_container.get_all_tasks
			Printer.print_list(tasks)
		when "group"
			grouped_tasks = @task_container.grouped_tasks 
			Printer.print_list_without_group(grouped_tasks) 
		when "overdue"
			overdue_tasks = @task_container.overdue_tasks
			Printer.print_list(overdue_tasks)
		else
			due_regx = Regexp.new('^due ')
			if str.match(due_regx) 
				due_date = str[4..-1]
				if(due_date == 'this-week')
					range = Utils.this_week
					range_tasks = @task_container.tasks_by_range(range)
					Printer.print_list(range_tasks)
				else
					due_date = Utils.parse_date(due_date)
					date_tasks = @task_container.tasks_by_date(due_date)
					Printer.print_list(date_tasks)
				end
			else
				group_regx = Regexp.new('^\+[A-Za-z0-9]+$')
				raise InvalidTaskException unless str.match(group_regx)
				group_tasks = @task_container.tasks_by_group(str)
				Printer.print_list_without_group(group_tasks)
			end
		end
	end

	def set(str)
		parsed_set = str.partition(" ")
		command, parameters = parsed_set[0], parsed_set.last
		case command
		when "date_task"
			if parameters.empty?
				@default_date = nil
				Printer.puts("Default date cleared.")
			else
				@default_date = Utils.parse_date(parameters)
				Printer.puts("Default date set to: #{Utils.human_date(@default_date)}.")
			end 
		when "group"
			if parameters.empty?
				@default_group = nil
				Printer.puts("Default group cleared.")
			else
				raise InvalidGroupFormatException unless Utils.valid_groupname?(parameters)
				@default_group = parameters
				Printer.puts("Default group set to: #{@default_group}")
			end 
		else
			raise InvalidTaskException
		end
	end

	def complete(str)
		raise InvalidTaskException unless Utils.is_number?(str)
		task = @task_container.complete_task(str.to_i)
		Printer.puts("Todo [#{task.id}: #{task.desc}] completed.")
	end

	def save(filename)
		FileManager.save(filename, @task_container)
		Printer.puts("#{filename} saved successfully.")
	end

	def open(filename)
		loop do
			begin
				Printer.print('All current tasks will be deleted, are you sure you want to continue? (y/n) ')
				response = Input.response()
				if response == "y" || response == "yes"
					@task_container = FileManager.open(filename)
					Printer.puts("#{filename} loaded successfully.")
					break
				elsif response == "n" || response == "no"
					break
				end
			rescue Exception => e
				Logger.log(e)
				Printer.puts(e.message)
			end
		end
	end


	def ac(str)
		raise InvalidTaskException unless str.empty?
		@task_container.archive_completed
		Printer.puts('All completed todos have been archived.')
	end
end