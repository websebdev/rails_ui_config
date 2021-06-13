module RailsUiConfig
  module Config
    class Field
      NAMES = [
        :allow_concurrency, :asset_host, :autoflush_log,
        :cache_classes, :cache_store, :consider_all_requests_local, :console,
        :eager_load, :exceptions_app, :file_watcher, :filter_parameters,
        :force_ssl, :helpers_paths, :hosts, :host_authorization, :logger, :log_formatter,
        :log_tags, :railties_order, :relative_url_root, :secret_key_base,
        :ssl_options,
        :session_options, :time_zone, :reload_classes_only_on_change,
        :beginning_of_week, :filter_redirect, :x, :enable_dependency_loading,
        :read_encrypted_secrets, :log_level, :content_security_policy_report_only,
        :content_security_policy_nonce_generator, :content_security_policy_nonce_directives,
        :require_master_key, :credentials, :disable_sandbox, :add_autoload_paths_to_load_path,
        :rake_eager_load, "public_file_server.headers"
      ]
      TYPES = [:string, :boolean, :symbol]

      attr_accessor :name, :type, :value

      def initialize(name:, value: nil, type: :string)
        @name = name
        @value = value
        @type = type
      end

      def config_line_with_value
        "#{config_line} = #{value}\n"
      end

      def config_line
        "config.#{name}"
      end
    end
  end
end
