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

Puppet::Type.newtype(:aem_outbox_replication_agent)do

  ensurable

  newparam :name, :namevar => false do
    desc 'AEM outbox replication agent name'
    validate do |value|
      fail 'outbox replication agent name must be provided' if value == ''
    end
  end

  newparam :run_mode do
    desc 'AEM run mode where the outbox replication agent is'
    validate do |value|
      unless ['author', 'publish'].include? value
        raise ArgumentError, 'run_mode should be author or publish'
      end
    end
  end

  newparam :title do
    desc 'AEM outbox replication agent title'
    validate do |value|
      value = ''
    end
  end

  newparam :description do
    desc 'AEM outbox replication agent description'
    validate do |value|
      value = ''
    end
  end

  newparam :dest_base_url do
    desc 'AEM outbox replication agent destination base URL'
    validate do |value|
      value = ''
    end
  end

  newparam :user_id do
    desc 'AEM outbox replication agent user ID'
    validate do |value|
      value = nil
    end
  end

  newparam :log_level do
    desc 'AEM outbox replication agent log level'
    validate do |value|
      value = nil
    end
  end

  newparam :force do
    desc 'Set to true to force outbox replication agent to be created if it doesn\'t exist or updated if it already exists'
    validate do |value|
      if value == ''
        value = false
      end
    end
  end

end
