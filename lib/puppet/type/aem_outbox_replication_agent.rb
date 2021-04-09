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

Puppet::Type.newtype(:aem_outbox_replication_agent) do
  ensurable

  def self.title_patterns
    [[/^(.*)$/, [[:name, ->(x) { x }]]]]
  end

  newparam :name do
    isnamevar
    desc 'AEM outbox replication agent name'
    validate do |value|
      raise ArgumentError.new('outbox replication agent name must be provided') if value == ''
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

  newparam :run_mode do
    desc 'AEM run mode where the outbox replication agent is'
    validate do |value|
      raise ArgumentError.new('run_mode should be author or publish') unless %w[author publish].include? value
    end
  end

  newparam :title do
    desc 'AEM outbox replication agent title'
  end

  newparam :description do
    desc 'AEM outbox replication agent description'
  end

  newparam :dest_base_url do
    desc 'AEM outbox replication agent destination base URL'
  end

  newparam :user_id do
    desc 'AEM outbox replication agent user ID'
    validate do |value|
      value = nil if value == ''
    end
  end

  newparam :log_level do
    desc 'AEM outbox replication agent log level'
    validate do |value|
      value = nil if value == ''
    end
  end

  newparam :force do
    desc 'Set to true to force outbox replication agent to be created if it doesn\'t exist or updated if it already exists'
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
