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

# TODO: Figure out a better way to have an aem_user_alias rather than copy pasting the code from aem_user
Puppet::Type.type(:aem_user_alias).provide(:aem, parent: PuppetX::ShineSolutions::PuppetAemResources) do
  # Create a user.
  # When force is set to true and if the user already exists then it will be deleted before recreated.
  def create
    user = client(resource).user(resource[:path], resource[:name])
    results = []
    results.push(user.delete) if resource[:force] == true && user.exists.data == true
    results.push(user.create(resource[:password]))
    results.push(user.add_to_group(resource[:group_path], resource[:group_name])) if !resource[:group_path].nil? && !resource[:group_name].nil?
    resource[:permission]&.each do |permission_path, permission_array|
      results.push(user.set_permission(permission_path, permission_array.join(',')))
    end
    handle_multi(results)
  end

  # Delete the user.
  def destroy
    user = client(resource).user(resource[:path], resource[:name])
    result = user.delete
    handle(result)
  end

  # Check whether the user exists or not.
  # When force is set to true and if the user already exists then it will be deleted before recreated.
  def exists?
    if resource[:force] == true
      false
    else
      user = client(resource).user(resource[:path], resource[:name])
      user.exists.data
    end
  end

  def change_password
    user = client_opts(aem_id: resource[:aem_id], aem_username: resource[:name], aem_password: resource[:old_password]).user(resource[:path], resource[:name])
    result = user.change_password(resource[:old_password], resource[:new_password])
    handle(result)
  end

  def add_to_group
    user = client(resource).user(resource[:path], resource[:name])
    result = user.add_to_group(resource[:group_path], resource[:group_name])
    handle(result)
  end

  def set_permission
    user = client(resource).user(resource[:path], resource[:name])
    results = []
    resource[:permission]&.each do |permission_path, permission_array|
      results.push(user.set_permission(permission_path, permission_array.join(',')))
    end
    handle_multi(results)
  end
end
