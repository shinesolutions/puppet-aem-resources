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

Puppet::Type.newtype(:aem_aem) do
  ensurable do
    newvalue(:login_page_is_ready) do
      provider.get_login_page_wait_until_ready
    end

    newvalue(:aem_health_check_is_ok) do
      provider.get_aem_health_check_wait_until_ok
    end

    newvalue(:install_status_is_finished) do
      provider.get_install_status_wait_until_finished
    end

    newvalue(:all_agents_removed) do
      provider.remove_all_agents
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

  newparam :tags do
    desc 'AEM HealthCheck tags'
    validate do |value|
      value = nil if value == ''
    end
  end

  newparam :combine_tags_or do
    desc 'AEM HealthCheck change AND to OR'
    validate do |value|
      value = nil if value == ''
    end
  end

  newparam :run_mode do
    desc 'AEM run mode where the replication agent is'
    validate do |value|
      value = nil if value == ''
    end
  end

  newparam :retries_max_tries do
    desc 'Maximum number of tries'
    validate do |value|
      value = 30 if value == ''
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
      value = 2 if value == ''
    end
  end
end
