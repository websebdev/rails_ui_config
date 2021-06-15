module RailsUiConfig
	module Config
    class Environment
      include ActiveModel::Model

      attr_accessor :file_path, :env, :fields, :file_manager
      attr_writer :lines

      def self.find(env)
        new(env: env)
      end

      def initialize(env: "development")
        @env = env
        @file_path = Rails.root.join("config/environments/#{@env}.rb").to_s
        @fields = []
        @file_manager = RailsUiConfig::Config::RubyFileManager.new(@file_path)

        Environment::Field::OPTIONS.keys.each do |name|
          @fields << Environment::Field.new(name: name, value: @file_manager.get_current_option_value(name))
        end
      end

      def update(options = {})
        options.each do |name, value|
          fields.find {|f| f.name.to_s == name.to_s}.value = value
        end

        save(options.keys)
      end

      def save(option_names)
        option_names.each do |option_name|
          field = fields.find {|f| f.name.to_s == option_name.to_s}
          file_manager.update_option(field.name, field.value)
        end

        file_manager.save
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
    end
  end
end
