module RailsUiConfig
	module Config
    class Environment
      include ActiveModel::Model

      attr_accessor :file_path, :env, :fields
      attr_writer :lines

      def self.find(env)
        new(env: env)
      end

      def initialize(env: "development")
        @env = env
        @file_path = Rails.root.join("config/environments/#{@env}.rb").to_s
        @fields = []

        Field::OPTIONS.keys.each do |name|
          @fields << Field.new(name: name, value: get_current_option(name))
        end
      end

      def lines
        @lines ||= File.readlines(file_path)
      end

      def update(options = {})
        options.each do |name, value|
          fields.find {|f| f.name.to_s == name.to_s}.value = value
        end

        save(options.keys)
      end

      def save(option_names)
        end_index = lines.find_index {|l| l == "end\n"}

        option_names.each do |option_name|
          field = fields.find {|f| f.name.to_s == option_name.to_s}


          index = lines.find_index {|l| l.split("=").first.strip == field.config_line}

          if index # if the config is already there, replace it
            if field.value.blank?
              lines.delete_at(index)
            else
              spaces = " " * lines[index][/\A */].size
              lines[index] = "#{spaces}#{field.config_line_with_value}"
            end
          elsif field.value.present? # if not, just add it at the bottom
            spaces = " " * lines[end_index - 1][/\A */].size
            lines.insert(end_index, "#{spaces}#{field.config_line_with_value}")
          end
        end

        File.write(file_path, lines.join)
      end

      def to_param
        env
      end

      def persisted?
        true
      end

      def to_model
        self
      end

      def model_name
        ActiveModel::Name.new(self.class, nil, "environment")
      end

      private

      def get_current_option(option_name)
        line = lines.find {|l| l.split("=").first.strip == "config.#{option_name}"}

        line.split("=").last.gsub(" ", "").sub("\n", "") if line
      end
    end
  end
end
