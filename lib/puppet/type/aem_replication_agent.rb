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

Puppet::Type.newtype(:aem_replication_agent) do
  ensurable

  def self.title_patterns
    [[/^(.*)$/, [[:name, ->(x) { x }]]]]
  end

  newparam :name do
    isnamevar
    desc 'AEM replication agent name'
    validate do |value|
      raise ArgumentError.new('replication agent name must be provided') if value == ''
    end
  end

  newparam :aem_id do
    isnamevar
    desc 'AEM instance ID'
  end

  newparam :run_mode do
    desc 'AEM run mode where the replication agent is'
    validate do |value|
      unless %w[author publish].include? value
        raise ArgumentError.new('run_mode should be author or publish')
      end
    end
  end

  newparam :title do
    desc 'AEM replication agent title'
  end

  newparam :description do
    desc 'AEM replication agent description'
  end

  newparam :dest_base_url do
    desc 'AEM replication agent destination base URL'
  end

  newparam :transport_user do
    desc 'AEM replication agent transport user\'s username'
    validate do |value|
      value = nil if value == ''
    end
  end

  newparam :transport_password do
    desc 'AEM replication agent transport user\'s password'
    validate do |value|
      value = nil if value == ''
    end
  end

  newparam :log_level do
    desc 'AEM replication agent log level'
    validate do |value|
      value = nil if value == ''
    end
  end

  newparam :retry_delay do
    desc 'AEM replication agent retry delay in milliseconds'
    validate do |value|
      value = nil if value == ''
    end
  end

  newparam :force do
    desc 'Set to true to force replication agent to be created if it doesn\'t exist or updated if it already exists'
    validate do |value|
      value = false if value == ''
    end
  end
end
