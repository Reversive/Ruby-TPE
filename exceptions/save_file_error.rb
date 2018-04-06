class SaveFileError < StandardError
    def message
        'Unable to save file.'
    end
end