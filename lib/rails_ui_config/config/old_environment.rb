module RailsUiConfig
	module Config
    class Environment
      include ActiveModel::Model

      ENVS = {
        development: { path: "config/environments/development.rb"},
        production: { path: "config/environments/production.rb"},
        test: { path: "config/environments/test.rb"},
        application: { path: "config/application.rb"}
      }

      attr_accessor :file_path, :name, :config
      delegate :fields, to: :config

      def self.find(name)
        new(name: name.to_sym)
      end

      def self.all
        ENVS.keys.map { |env| new(name: env) }
      end

      def initialize(name: :development)
        @name = name
        @file_path = Rails.root.join(ENVS[name][:path]).to_s
        @config = Config.load(@file_path)
      end

      def update(options = {})
        options.each do |name, value|
          config[name] = value
        end

        config.save
      end

      def to_param
        name
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
