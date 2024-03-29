# frozen_string_literal: true

# Copyright 2016-2021 Shine Solutions Group
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

require_relative '../../../puppet_x/shinesolutions/puppet_aem_resources'

Puppet::Type.type(:aem_node).provide(:aem, parent: PuppetX::ShineSolutions::PuppetAemResources) do
  # Create a node.
  def create
    node = client(resource).node(resource[:path], resource[:name])
    result = call_with_readiness_check(node, 'create', [resource[:type]], resource)
    handle(result)
  end

  # Delete the node.
  def destroy
    node = client(resource).node(resource[:path], resource[:name])
    result = call_with_readiness_check(node, 'delete', [], resource)
    handle(result)
  end

  # Check whether the node exists or not.
  def exists?
    node = client(resource).node(resource[:path], resource[:name])
    node.exists.data
  end
end
