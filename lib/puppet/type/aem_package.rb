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

Puppet::Type.newtype(:aem_package) do
  ensurable do
    newvalue(:archived) do
      provider.archive
    end

    newvalue(:present) do
      if @resource.provider && @resource.provider.respond_to?(:create)
        @resource.provider.create
      else
        @resource.create
      end
      nil
    end

    newvalue(:reinstall) do
      if @resource.provider && @resource.provider.respond_to?(:create)
        @resource.provider.reinstall
      else
        @resource.reinstall
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
    desc 'AEM package name'
    validate do |value|
      raise ArgumentError.new('Name must be provided') if value == ''
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

  newparam :version do
    desc 'AEM package version'
    validate do |value|
      raise ArgumentError.new('Version must be provided') if value == ''
    end
  end

  newparam :group do
    desc 'AEM package group'
    validate do |value|
      raise ArgumentError.new('Group must be provided') if value == ''
    end
  end

  newparam :path do
    desc 'Path where the package file to be uploaded is located at'
    validate do |value|
      raise ArgumentError.new('Package file path must be provided') if value == ''
    end
  end

  newparam :force do
    desc 'Set to true to force package installation even if it is already installed, default to false'
    validate do |value|
      value = false if value == ''
    end
  end

  newparam :replicate do
    desc 'Set to true to replicate package after installation, default to false'
    validate do |value|
      value = false if value == ''
    end
  end

  newparam :activate do
    desc 'Set to true to activate all filters in the package after installation, default to false'
    validate do |value|
      value = false if value == ''
    end
  end

  newparam :filter do
    desc 'AEM package filter'
  end

  newparam :retries_max_tries do
    desc 'Maximum tries when waiting for package to be uploaded/installed'
    validate do |value|
      value = 30 if value == ''
    end
  end

  newparam :retries_base_sleep_seconds do
    desc 'Starting wait delay in seconds when waiting for package to be uploaded/installed'
    validate do |value|
      value = 2 if value == ''
    end
  end

  newparam :retries_max_sleep_seconds do
    desc 'Maximum wait delay in seconds when waiting for package to be uploaded/installed'
    validate do |value|
      value = 2 if value == ''
    end
  end
end
