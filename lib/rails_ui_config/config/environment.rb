require "parser/current"
require "rubocop"
require "rubocop-ast"

require "rails_ui_config/config/environment/config"
require "rails_ui_config/config/environment/field.rb"
require "rails_ui_config/config/environment/processor.rb"

module RailsUiConfig
	module Config
    class Environment
      include ActiveModel::Model

      RUBY_VERSION = 2.7

      ENVS = {
        development: { path: "config/environments/development.rb"},
        production: { path: "config/environments/production.rb"},
        test: { path: "config/environments/test.rb"},
        application: { path: "config/application.rb"}
      }

      attr_reader :name, :fields

      def self.find(name)
        new(name: name.to_sym)
      end

      def self.all
        ENVS.keys.map { |env| new(name: env) }
      end

      def initialize(name: :development)
        @name = name
        @file_path = Rails.root.join(ENVS[name][:path]).to_s

        @processed_source = process_source
        @fields = build_fields

        @rewriter = Parser::Source::TreeRewriter.new(processed_source.buffer)
      end

      def update(options = {})
        options.each do |name, value|
          # TODO: It should remove the config line if value is empty
          next if value.empty?

          node = fields.find {|f| f.name == name.to_sym }.node

          # Skip any node that the processor does not support yet
          next unless node.type.in?([:true, :false, :hash, :sym])

          case node.type
          when :sym
            new_value = ":#{value}"
          else
            new_value = value
          end

          rewriter.replace(node.location.expression, new_value)
        end

        File.write(file_path, rewriter.process)

        # Always return true until we have actual validations
        true
      end

      def reload
        @processed_source = process_source
        @fields = build_fields

        @rewriter = Parser::Source::TreeRewriter.new(processed_source.buffer)

        self
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

      private

      attr_reader :file_path, :rewriter, :processed_source

      def build_fields
        field_names = RailsUiConfig::Config::Environment::Field::OPTIONS.keys
        fields = field_names.map { |name| RailsUiConfig::Config::Environment::Field.new(name: name) }

        load_field_values(fields)

        fields
      end

      def load_field_values(fields_to_process)
        processor = Processor.new(fields_to_process, File.readlines(file_path))
        processed_source.ast.each_node { |node| processor.process(node) }
      end

      def process_source
        code = File.read(file_path)
        RuboCop::ProcessedSource.new(code, RUBY_VERSION)
      end
    end
  end
end
