module RailsUiConfig
  module Config
    class RubyFileManager
      attr_accessor :file_path, :lines

      def initialize(file_path)
        @file_path = file_path
        @lines ||= File.readlines(file_path)
      end

      def get_current_option_value(option_name)
        line = lines.find {|l| l.split("=").first.strip == "config.#{option_name}"}

        line.split("=").last.gsub(" ", "").sub("\n", "") if line
      end

      def update_option(name, value)
        index = option_index(name)

        if index # if the config is already there, replace it
          if value.blank?
            lines.delete_at(index)
          else
            indentation = calculate_indentation(lines[index])
            lines[index] = new_line(indentation, name, value)
          end
        elsif value.present? # if not, just add it at the bottom
          indentation = calculate_indentation(lines[end_index - 1])
          lines.insert(end_index, new_line(indentation, name, value))
        end
      end

      def save
        File.write(file_path, lines.join)
      end

      private

      def new_line(indentation, name, value)
        "#{indentation}config.#{name} = #{value}\n"
      end

      def calculate_indentation(line)
        " " * line[/\A */].size
      end

      def option_index(option_name)
        lines.find_index {|l| l.split("=").first.strip == "config.#{option_name}"}
      end

      def end_index
        lines.find_index {|l| l == "end\n"}
      end
    end
  end
end
