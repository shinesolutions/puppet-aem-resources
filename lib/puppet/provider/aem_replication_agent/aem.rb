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

Puppet::Type.type(:aem_replication_agent).provide(:aem, parent: PuppetX::ShineSolutions::PuppetAemResources) do
  # Create a replication agent.
  def create
    replication_agent = client(resource).replication_agent(resource[:run_mode], resource[:name])
    opts = { transport_user: resource[:transport_user], transport_password: resource[:transport_password], log_level: resource[:log_level], retry_delay: resource[:retry_delay] }
    result = replication_agent.create_update(resource[:title], resource[:description], resource[:dest_base_url], opts)
    handle(result)
  end

  # Delete the replication agent.
  def destroy
    replication_agent = client(resource).replication_agent(resource[:run_mode], resource[:name])
    result = replication_agent.delete
    handle(result)
  end

  # Check whether the replication agent exists or not.
  # When force is set to true, replication agent will be created if it doesn't exist or updated if it already exists.
  def exists?
    if resource[:force] == true
      false
    else
      replication_agent = client(resource).replication_agent(resource[:run_mode], resource[:name])
      replication_agent.exists.data
    end
  end
end
