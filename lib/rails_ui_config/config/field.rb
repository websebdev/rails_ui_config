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

      BOOLEAN_SUGGESTIONS = ["true", "false"]
      OPTIONS = {
        cache_classes: { suggestions: BOOLEAN_SUGGESTIONS },
        allow_concurrency: { suggestions: BOOLEAN_SUGGESTIONS },
        asset_host: {},
        autoflush_log: { suggestions: BOOLEAN_SUGGESTIONS },
        cache_classes: { suggestions: BOOLEAN_SUGGESTIONS },
        cache_store: { suggestions: [":file_store", ":mem_cache_store", ":memory_store", ":null_store", ":redis_cache_store"] },
        consider_all_requests_local: { suggestions: BOOLEAN_SUGGESTIONS },
        # console: { type: :??? },
        eager_load: { suggestions: BOOLEAN_SUGGESTIONS },
        exceptions_app: {},
        file_watcher: {},
        filter_parameters: {}, # array
        force_ssl: { suggestions: BOOLEAN_SUGGESTIONS },
        helpers_paths: {}, # array
        hosts: {}, # array
        host_authorization: {},
        logger: {}, # class
        log_formatter: {},
        log_tags: {}, # array
        railties_order: {},
        relative_url_root: {},
        secret_key_base: {},
        ssl_options: {}, # hash
        session_options: {}, # hash
        time_zone: {},
        reload_classes_only_on_change: { suggestions: BOOLEAN_SUGGESTIONS },
        beginning_of_week: { suggestions: [:sunday, :monday] },
        filter_redirect: {}, # array
        x: {}, # class
        enable_dependency_loading: { suggestions: BOOLEAN_SUGGESTIONS },
        read_encrypted_secrets: { suggestions: BOOLEAN_SUGGESTIONS },
        log_level: { suggestions: [":debug", ":info", ":warn", ":error", ":fatal", ":unknown"] },
        content_security_policy_report_only: { suggestions: BOOLEAN_SUGGESTIONS },
        content_security_policy_nonce_generator: {}, # no idea what is this
        content_security_policy_nonce_directives: {}, # no idea what is this
        require_master_key: { suggestions: BOOLEAN_SUGGESTIONS },
        credentials: {}, # hash / OrderedOptions
        disable_sandbox: { suggestions: BOOLEAN_SUGGESTIONS },
        add_autoload_paths_to_load_path: { suggestions: BOOLEAN_SUGGESTIONS },
        rake_eager_load: { suggestions: BOOLEAN_SUGGESTIONS },
        "public_file_server.headers": {}, # hash
        autoload_paths: {} # array
      }
      TYPES = [:string, :boolean, :symbol]

      attr_accessor :name, :type, :value

      def initialize(name:, value: nil, type: :symbol)
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
