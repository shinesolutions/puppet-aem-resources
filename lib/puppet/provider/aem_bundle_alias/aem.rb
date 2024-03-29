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
# TODO: Figure out a better way to have an aem_bundle_alias rather than copy pasting the code from aem_bundle
Puppet::Type.type(:aem_bundle_alias).provide(:aem, parent: PuppetX::ShineSolutions::PuppetAemResources) do
  # Start a bundle.
  def start
    client(resource).bundle(resource[:name]).start
  end

  # Stop a bundle.
  def stop
    client(resource).bundle(resource[:name]).stop
  end

  # Existence check defaults to true in order to simulate that the bundle exists.
  # ruby_aem does not currently provide bundle resource existence check.
  def exists?
    true
  end
end
