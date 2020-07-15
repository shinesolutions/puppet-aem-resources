# frozen_string_literal: true

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

Puppet::Type.newtype(:aem_ssl) do
  ensurable do

    newvalue(:present) do
      if @resource.provider&.respond_to?(:create)
        @resource.provider.create
      else
        @resource.create
      end
      nil
    end

    newvalue(:exists) do
      if @resource.provider&.respond_to?(:exists?)
        @resource.provider.exists?
      else
        @resource.exists?
      end
      nil
    end

    newvalue(:absent) do
      if @resource.provider&.respond_to?(:destroy)
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
    desc 'Description'
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

  newparam :https_hostname do
    desc 'AEM https hostname'
  end

  newparam :https_port do
    desc 'AEM https port'
  end

  newparam :keystore_password do
    desc 'Password for private keystore file'
    validate do |value|
      raise ArgumentError.new('intermediate_path must be provided') if value == ''
    end
  end

  newparam :truststore_password do
    desc 'Password for certificate file'
    validate do |value|
      raise ArgumentError.new('intermediate_path must be provided') if value == ''
    end
  end

  newparam :privatekey_file_path do
    desc 'Full path to the private key file'
    validate do |value|
      raise ArgumentError.new('intermediate_path must be provided') if value == ''
    end
  end

  newparam :certificate_file_path do
    desc 'Full path to the certificate key file'
    validate do |value|
      raise ArgumentError.new('intermediate_path must be provided') if value == ''
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

