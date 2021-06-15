module RailsUiConfig
  module Config
    class Environment
      class Config
        attr_accessor :file_path, :file_manager, :fields

        def initialize(file_path)
          @file_path = file_path
          @file_manager = RubyFileManager.new(@file_path)
          @fields = Field::OPTIONS.keys.map do |name|
            Field.new(name: name, value: @file_manager.get_current_option_value(name))
          end
        end

        def self.load(file_path)
          new(file_path)
        end

        def [](field_name)
          fields.find {|f| f.name.to_s == field_name.to_s}.value
        end

        def []=(field_name, field_value)
          fields.find {|f| f.name.to_s == field_name.to_s}.value = field_value
        end

        def save
          fields.each do |field|
            file_manager.update_option(field.name, field.value)
          end

          file_manager.save
        end
      end
    end
  end
end
