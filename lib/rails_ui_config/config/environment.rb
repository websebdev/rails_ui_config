module RailsUiConfig
	module Config
    class Environment
      # include ActiveModel::Model

      # TODO: Add missing options coming from Rails components like "active_storage.service"
      OPTION_NAMES = [
        :allow_concurrency, :asset_host, :autoflush_log,
        :cache_classes, :cache_store, :consider_all_requests_local, :console,
        :eager_load, :exceptions_app, :file_watcher, :filter_parameters,
        :force_ssl, :helpers_paths, :hosts, :host_authorization, :logger, :log_formatter,
        :log_tags, :railties_order, :relative_url_root, :secret_key_base,
        :ssl_options, :public_file_server,
        :session_options, :time_zone, :reload_classes_only_on_change,
        :beginning_of_week, :filter_redirect, :x, :enable_dependency_loading,
        :read_encrypted_secrets, :log_level, :content_security_policy_report_only,
        :content_security_policy_nonce_generator, :content_security_policy_nonce_directives,
        :require_master_key, :credentials, :disable_sandbox, :add_autoload_paths_to_load_path,
        :rake_eager_load
      ]

      OPTION_NAMES.each do |option_name|
        attr_accessor option_name
      end

      attr_accessor :file_path, :env
      attr_writer :lines

      def self.find(env)
        new(env: env)
      end

      def initialize(env: "development")
        @env = env
        @file_path = Rails.root.join("config/environments/#{@env}.rb").to_s

        OPTION_NAMES.each do |option_name|
          self.public_send("#{option_name}=", get_current_option(option_name))
        end
      end

      def lines
        @lines ||= File.readlines(file_path)
      end

      def update(options = {})
        OPTION_NAMES.each do |option_name|
          self.public_send("#{option_name}=", options[option_name])
        end

        save(options.keys)
      end

      def save(option_names)
        end_index = lines.find_index {|l| l == "end\n"}

        option_names.each do |option_name|
          value = self.public_send(option_name)
          next if value.nil?

          config = "config.#{option_name}"
          index = lines.find_index {|l| l.include? config}

          new_line = "  #{config} = #{value}\n"

          if index # if the config is already there, replace it
            lines[index] = new_line
          else # if not, just add it at the bottom
            lines.insert(end_index, new_line)
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
        line = lines.find {|l| l.include? "config.#{option_name}"}

        line.split("=").last.gsub(" ", "").sub("\n", "") if line
      end

    end
  end
end
