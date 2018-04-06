class LoadFileError < StandardError
    def message
        'Unable to load file.'
    end
end