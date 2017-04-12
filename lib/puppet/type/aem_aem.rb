=begin
Copyright 2016 Shine Solutions
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=end

Puppet::Type.newtype(:aem_aem)do

  ensurable do

    newvalue(:login_page_is_ready) do
      provider.get_login_page_wait_until_ready
    end

    newvalue(:aem_health_check_is_ok) do
      provider.get_aem_health_check_wait_until_ok
    end

  end

  newparam :name, :namevar => false do
    desc 'Description'
  end

  newparam :tags do
    desc 'AEM HealthCheck tags'
    validate do |value|
      if value == ''
        value = nil
      end
    end
  end

  newparam :combine_tags_or do
    desc 'AEM HealthCheck change AND to OR'
    validate do |value|
      if value == ''
        value = nil
      end
    end
  end

  newparam :retries_max_tries do
    desc 'Maximum number of tries'
    validate do |value|
      if value == ''
        value = 30
      end
    end
  end

  newparam :retries_base_sleep_seconds do
    desc 'Starting sleep duration in seconds'
    validate do |value|
      if value == ''
        value = 2
      end
    end
  end

  newparam :retries_max_sleep_seconds do
    desc 'Maximum sleep duration in seconds'
    validate do |value|
      if value == ''
        value = 2
      end
    end
  end

end
