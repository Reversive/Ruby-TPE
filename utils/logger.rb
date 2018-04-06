require_relative '../config.rb'

class Logger

	def initialize
		raise 'Unable to instantiate Logger'
	end

	def self.log(error)
		File.open(LOGFILEFULL, "a") do |f|
			time = Time.now.strftime("%d/%m/%Y %H:%M:%S")
			out = "[#{time}] #{error}: #{error.message}\n"
			f << out
			error.backtrace.each{|m| f << "[#{time}] #{error}: #{m}\n"}
			f << "\n"
		end
	end
end
