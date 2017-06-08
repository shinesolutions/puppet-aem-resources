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

Puppet::Type.type(:aem_repository).provide(:aem, parent: PuppetX::ShineSolutions::PuppetAemResources) do
  # Block repository writes.
  def block_writes
    client.repository.block_writes
  end

  # Unblock repository writes.
  def unblock_writes
    client.repository.unblock_writes
  end

  # Existence check defaults to true because repository should always exist in AEM.
  def exists?
    true
  end
end
