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

Puppet::Type.type(:aem_user).provide(:aem, parent: PuppetX::ShineSolutions::PuppetAemResources) do
  # Create a user.
  # When force is set to true and if the user already exists then it will be deleted before recreated.
  def create
    user = client(aem_id: resource[:aem_id]).user(resource[:path], resource[:name])
    results = []
    if resource[:force] == true && user.exists.data == true
      results.push(user.delete)
    end
    results.push(user.create(resource[:password]))
    if !resource[:group_path].nil? && !resource[:group_name].nil?
      results.push(user.add_to_group(resource[:group_path], resource[:group_name]))
    end
    unless resource[:permission].nil?
      resource[:permission].each do |permission_path, permission_array|
        results.push(user.set_permission(permission_path, permission_array.join(',')))
      end
    end
    handle_multi(results)
  end

  # Delete the user.
  def destroy
    user = client(aem_id: resource[:aem_id]).user(resource[:path], resource[:name])
    result = user.delete
    handle(result)
  end

  # Check whether the user exists or not.
  # When force is set to true and if the user already exists then it will be deleted before recreated.
  def exists?
    if resource[:force] == true
      false
    else
      user = client(aem_id: resource[:aem_id]).user(resource[:path], resource[:name])
      user.exists.data
    end
  end

  def change_password
    user = client(username: resource[:name], password: resource[:old_password]).user(resource[:path], resource[:name])
    result = user.change_password(resource[:old_password], resource[:new_password])
    handle(result)
  end

  def add_to_group
    user = client(aem_id: resource[:aem_id]).user(resource[:path], resource[:name])
    result = user.add_to_group(resource[:group_path], resource[:group_name])
    handle(result)
  end

  def set_permission
    user = client(aem_id: resource[:aem_id]).user(resource[:path], resource[:name])
    results = []
    unless resource[:permission].nil?
      resource[:permission].each do |permission_path, permission_array|
        results.push(user.set_permission(permission_path, permission_array.join(',')))
      end
    end
    handle_multi(results)
  end
end
