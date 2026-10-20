# frozen_string_literal: true

require 'yaml'

# Helpers shared by the provider unit tests. The tests stub the ruby_aem client with
# instance_double of the real ruby_aem classes, so they need no AEM and no network.
module ProviderSpecHelpers
  # Build a resource the way a catalog does (Puppet::Resource#to_ral), so attributes such as
  # `title` stay resource parameters like in the spec/acceptance scenarios
  def build_resource(type, title, parameters)
    Puppet::Type.type(type).new(Puppet::Resource.new(type, title, parameters: parameters))
  end

  # A real RubyAem::Result, as ruby_aem returns for a successful call
  def aem_result(message, data = nil, status_code = 200, body = '')
    result = RubyAem::Result.new(message, RubyAem::Response.new(status_code, body, {}))
    result.data = data
    result
  end

  # The %{...} keys ruby_aem's conf/spec.yaml interpolates for an action. ruby_aem raises KeyError
  # when the call params miss one, which is how the flush agent alias_update bug showed up
  def ruby_aem_spec_keys(resource_name, action)
    spec = YAML.load_file(File.join(Gem.loaded_specs['ruby_aem'].full_gem_path, 'conf', 'spec.yaml'))
    params = spec.fetch(resource_name).fetch('actions').fetch(action).fetch('params')
    params.to_s.scan(%r{%\{(\w+)\}}).flatten.map(&:to_sym).uniq
  end
end

RSpec.configure do |c|
  c.include ProviderSpecHelpers
end
