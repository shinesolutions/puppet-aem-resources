require 'ruby_aem'

module PuppetX
  module ShineSolutions
    class PuppetAemResources < Puppet::Provider

      @@label = '[puppet-aem-resources]'

      def self.client()
        config_file = File.join([ File.dirname(Puppet.settings[:config]), 'aem.yaml' ])
        if File.exist?(config_file)
          config = YAML.load_file(config_file)
        end

        # Set RubyAem::Aem parameters in order of priority:
        # - use environment variable if provided, variable name is prefixed with 'aem_', e.g. aem_username, aem_password, aem_debug
        # - otherwise, use config file property if provided in aem.yaml
        # - otherwise, use RubyAem::Aem's default value
        params = {}
        ['username', 'password', 'protocol', 'host', 'port', 'debug'].each { |field|
          env_field = 'aem_%s' % [field]
          if ENV[env_field] != nil
            params[field.to_sym] = ENV[env_field]
          elsif config != nil and config[field.to_sym] != nil
            params[field.to_sym] = config[field.to_sym]
          else
            Puppet.debug("#{@@label} AEM #{field} field is not specified, using default value from ruby_aem")
          end
        }

        RubyAem::Aem.new(params)
      end

      def client()
        self.class.client()
      end

      def handle(result)
        Puppet.debug("#{@@label} Response status code: #{result.response.status_code}")

        if (result.response.body != nil)
          Puppet.debug("#{@@label} Response body:\n#{result.response.body[0..500]}")
        end

        Puppet.debug("#{@@label} Response headers:\n#{result.response.headers}")
        Puppet.info("#{@@label} #{result.message}")
      end

      def handle_multi(results)
        results.each { |result| handle(result) }
      end

    end
  end
end
