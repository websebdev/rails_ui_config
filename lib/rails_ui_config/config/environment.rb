module RailsUiConfig
	module Config
    class Environment
      include ActiveModel::Model

      attr_accessor :file_path, :env, :config
      delegate :fields, to: :config

      def self.find(env)
        new(env: env)
      end

      def initialize(env: "development")
        @env = env
        @file_path = Rails.root.join("config/environments/#{@env}.rb").to_s
        @config = Environment::Config.load(@file_path)
      end

      def update(options = {})
        options.each do |name, value|
          config[name] = value
        end

        config.save
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
