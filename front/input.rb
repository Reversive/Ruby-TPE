require_relative 'printer'

class Input

	def initialize
		raise 'Unable to instantiate Input'
	end

	def self.get()
		prompt = "> " 
		Printer.print(prompt)
		gets.chomp.strip
	end

	def self.response()
		gets.chomp.strip
	end
end