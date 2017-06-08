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

Puppet::Type.type(:aem_path).provide(:aem, parent: PuppetX::ShineSolutions::PuppetAemResources) do
  # Activate nodes under a path.
  # This is applicable only to nodes that are not deactivated, regardless whether they are modified or not.
  def activate
    client.path(resource[:name]).activate(true, false)
  end

  # Existence check defaults to true in order to simulate that the path exists.
  # ruby_aem does not currently provide path resource existence check.
  def exists?
    true
  end
end
