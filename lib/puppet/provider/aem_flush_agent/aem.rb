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

Puppet::Type.type(:aem_flush_agent).provide(:aem, parent: PuppetX::ShineSolutions::PuppetAemResources) do
  # Create a flush agent.
  def create
    flush_agent = client(resource).flush_agent(resource[:run_mode], resource[:name])
    opts = { log_level: resource[:log_level], retry_delay: resource[:retry_delay] }
    result = flush_agent.create_update(resource[:title], resource[:description], resource[:dest_base_url], opts)
    handle(result)
  end

  # Delete the flush agent.
  def destroy
    flush_agent = client(resource).flush_agent(resource[:run_mode], resource[:name])
    result = flush_agent.delete
    handle(result)
  end

  # Check whether the flush agent exists or not.
  # When force is set to true, flush agent will be created if it doesn't exist or updated if it already exists.
  def exists?
    if resource[:force] == true
      false
    else
      flush_agent = client(resource).flush_agent(resource[:run_mode], resource[:name])
      flush_agent.exists.data
    end
  end
end
