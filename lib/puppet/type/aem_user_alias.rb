# Copyright 2016-2019 Shine Solutions
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

Puppet::Type.newtype(:aem_user_alias) do
  ensurable do
    newvalue(:password_changed) do
      provider.change_password
    end

    newvalue(:added_to_group) do
      provider.add_to_group
    end

    newvalue(:has_permission) do
      provider.set_permission
    end

    newvalue(:present) do
      if @resource.provider && @resource.provider.respond_to?(:create)
        @resource.provider.create
      else
        @resource.create
      end
      nil
    end

    newvalue(:absent) do
      if @resource.provider && @resource.provider.respond_to?(:destroy)
        @resource.provider.destroy
      else
        @resource.destroy
      end
      nil
    end
  end

  def self.title_patterns
    [[/^(.*)$/, [[:name, ->(x) { x }]]]]
  end

  newparam :name do
    isnamevar
    desc 'User name'
    validate do |value|
      raise ArgumentError.new('User name must be provided') if value == ''
    end
  end

  newparam :aem_id do
    isnamevar
    desc 'AEM instance ID'
  end

  newparam :aem_username do
    desc 'AEM username'
  end

  newparam :aem_password do
    desc 'AEM password'
  end

  newparam :path do
    desc 'User path'
    validate do |value|
      raise ArgumentError.new('User path must be provided') if value == ''
    end
  end

  newparam :password do
    desc 'User password'
  end

  newparam :old_password do
    desc 'Old user password'
  end

  newparam :new_password do
    desc 'New user password'
  end

  newparam :group_path do
    desc 'Group path'
  end

  newparam :group_name do
    desc 'Group name'
  end

  newparam :permission do
    desc 'User permission'
  end

  newparam :force do
    desc 'Set to true to force user creation, if the user already exists then it will be deleted before recreated, default to false'
    validate do |value|
      value = false if value == ''
    end
  end

  newparam :retries_max_tries do
    desc 'Maximum number of tries'
    validate do |value|
      value = 60 if value == ''
    end
  end

  newparam :retries_base_sleep_seconds do
    desc 'Starting sleep duration in seconds'
    validate do |value|
      value = 2 if value == ''
    end
  end

  newparam :retries_max_sleep_seconds do
    desc 'Maximum sleep duration in seconds'
    validate do |value|
      value = 5 if value == ''
    end
  end
end
