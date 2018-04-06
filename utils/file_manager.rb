require 'yaml'
require_relative '../config'
require_relative 'logger'
require_relative 'utils'
require_relative '../exceptions/invalid_filename_exception'
require_relative '../exceptions/save_file_error'
require_relative '../exceptions/load_file_error'

class FileManager

	def initialize
		raise 'Unable to instantiate FileManager'
	end

	def self.save(filename, object)
		raise InvalidFilenameException unless Utils.valid_filename?filename
		serialized_object = YAML.dump(object)
		begin
			file = File.new("#{SAVEDIRFULL}#{filename}.yaml", "w")
			file << serialized_object
			file.close
		rescue Exception => e
			Logger.log(e)
			raise SaveFileError
		end
	end

	def self.open(filename)
		raise InvalidFilenameException unless Utils.valid_filename?filename
		begin
			object = YAML.load_file("#{SAVEDIRFULL}#{filename}.yaml")
		rescue Exception => e
			Logger.log(e)
			raise LoadFileError
		end
	end
end