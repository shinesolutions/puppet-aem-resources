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

Puppet::Type.type(:aem_group).provide(:aem, :parent => PuppetX::ShineSolutions::PuppetAemResources) do

  # Create a group.
  # When force is set to true and if the group already exists then it will be deleted before recreated.
  def create
    group = client().group(resource[:path], resource[:name])
    results = []
    if resource[:force] == true && group.exists().data == true
      results.push(group.delete())
    end
    results.push(group.create())
    if !resource[:parent_group_path].nil? && !resource[:parent_group_name].nil?
      parent_group = client().group(resource[:parent_group_path], resource[:parent_group_name])
      results.push(parent_group.add_member(resource[:name]))
    end
    if !resource[:member_group_path].nil? && !resource[:member_group_name].nil?
      results.push(group.add_member(resource[:member_group_name]))
    end
    handle_multi(results)
  end

  # Delete the group.
  def destroy
    group = client().group(resource[:path], resource[:name])
    result = group.delete()
    handle(result)
  end

  # Check whether the group exists or not.
  def exists?
    if resource[:force] == true
      return false
    else
      group = client().group(resource[:path], resource[:name])
      group.exists().data
    end
  end

end
