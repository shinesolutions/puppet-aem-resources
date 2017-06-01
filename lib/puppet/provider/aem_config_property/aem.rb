# Copyright 2016-2017 Shine Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative '../../../puppet_x/shinesolutions/puppet_aem_resources.rb'

Puppet::Type.type(:aem_config_property).provide(:aem, :parent => PuppetX::ShineSolutions::PuppetAemResources) do

  # Create a config property.
  def create
    config_property = client().config_property(resource[:name], resource[:type], resource[:value])
    result = config_property.create(resource[:run_mode], resource[:config_node_name])
    handle(result)
  end

  # Existence check defaults to false in order to force create the config property.
  # ruby_aem does not currently provide config_property resource existence check.
  def exists?
    false
  end

end
