module RailsUiConfig
	module Config
    class Environment
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

          return if invalid_parent?(node, field)

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

        private

        # Make sure if the field has a parent, ex. "config.public_server.headers" to check the parent matches too
        def invalid_parent?(node, field)
          field.parent && node.children.first.children.last != field.parent
        end
      end
    end
  end
end
