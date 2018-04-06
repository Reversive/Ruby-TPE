class InvalidGroupFormatException < StandardError
    def message
        'Error: Group names must begin with a \'+\' and must not contain spaces'
    end
end