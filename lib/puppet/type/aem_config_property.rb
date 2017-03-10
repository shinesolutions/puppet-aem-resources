=begin
Copyright 2016 Shine Solutions
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=end

Puppet::Type.newtype(:aem_config_property)do

  ensurable

  newparam :name, :namevar => false do
    desc 'AEM property name'
    validate do |value|
      fail 'AEM property name must be provided' if value == ''
    end
  end

  newparam :type do
    desc 'AEM property type (e.g. String, Boolean)'
    validate do |value|
      value = 'String'
    end
  end

  newparam :value do
    desc 'AEM property value'
    validate do |value|
      fail 'AEM property value must be provided' if value == ''
    end
  end

  newparam :run_mode do
    desc 'AEM run mode where the config property is'
    validate do |value|
      unless ['author', 'publish'].include? value
        raise ArgumentError, 'run_mode should be author or publish'
      end
    end
  end

  newparam :config_node_name do
    desc 'AEM config node name'
    validate do |value|
      fail 'AEM config node name must be provided' if value == ''
    end
  end

end
