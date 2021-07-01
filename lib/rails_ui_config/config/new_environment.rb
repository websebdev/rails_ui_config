require "parser/current"
require "rubocop"
require "rubocop-ast"

module RailsUiConfig
	module Config
    class NewEnvironment
      class Processor < Parser::AST::Processor
        include RuboCop::AST::Traversal

        def initialize(fields, file_lines)
          @fields = fields
          @file_lines = file_lines
        end

        def on_send(node)
          return unless node.respond_to?(:method_name)

          field = @fields.find { |f| "#{f.name}=".to_sym == node.method_name }
          return unless field
          value_node = node.children.last

          # Make sure if the field has a parent, ex. "config.public_server.headers" to check the parent matches too
          return if field.parent && node.children.first.children.last != field.parent

          case value_node.type
          when :false
            field.value = false
          when :true
            field.value = true
          when :sym
            field.value = value_node.value
          when :hash
            # TODO: Find a better way to get the hash?
            first_line = node.first_line - 1
            last_line = node.last_line - 1
            field.value = @file_lines[first_line..last_line].map(&:strip).join.partition("{")[1..-1].join
            # field.value = value_node.keys.map(&:value).zip(value_node.values.map(&:value)).to_h.to_s
          end

          field.node = value_node
        end
      end

      include ActiveModel::Model

      ENVS = {
        development: { path: "config/environments/development.rb"},
        production: { path: "config/environments/production.rb"},
        test: { path: "config/environments/test.rb"},
        application: { path: "config/application.rb"}
      }

      attr_accessor :file_path, :name, :fields

      def self.find(name)
        new(name: name.to_sym)
      end

      def self.all
        ENVS.keys.map { |env| new(name: env) }
      end

      def initialize(name: :development)
        @name = name
        @file_path = Rails.root.join(ENVS[name][:path]).to_s

        @fields = RailsUiConfig::Config::Environment::Field::OPTIONS.keys.map do |name|
          RailsUiConfig::Config::Environment::Field.new(name: name)
        end

        @code = File.read(@file_path)
        @source = RuboCop::ProcessedSource.new(@code, 2.7)

        @rewriter = Parser::Source::TreeRewriter.new(@source.buffer)
        @processor = Processor.new(@fields, File.readlines(@file_path))
        @source.ast.each_node { |n| @processor.process(n) }
      end

      def update(options = {})
        options.each do |name, value|
          next if value.empty?
          node = fields.find {|f| f.name == name.to_sym }.node
          next unless node.type.in?([:true, :false, :hash, :sym])
          # next if node.type != :true
          case node.type
          when :sym
            new_value = ":#{value}"
          else
            new_value = value
          end

          @rewriter.replace(node.loc.expression, new_value)
        end

        File.write(file_path, @rewriter.process)
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
