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

require_relative '../../../puppet_x/shinesolutions/puppet_aem_resources.rb'
require 'tempfile'
require 'retries'

Puppet::Type.type(:aem_ssl).provide(:aem, parent: PuppetX::ShineSolutions::PuppetAemResources) do
  # Upload ssl to the AEM.
  def create
    ssl = client(resource).ssl
    opts = {
      keystore_password: resource[:keystore_password],
      truststore_password: resource[:truststore_password],
      https_hostname: resource[:https_hostname],
      https_port: resource[:https_port],
      certificate_file_path: resource[:certificate_file_path],
      privatekey_file_path: resource[:privatekey_file_path]
    }
    build_opts = {
      _retries: {
        max_tries: resource[:retries_max_tries],
        base_sleep_seconds: resource[:retries_base_sleep_seconds],
        max_sleep_seconds: resource[:retries_max_sleep_seconds]
      }
    }
    result = call_with_readiness_check(ssl, 'enable_wait_until_ready', [**opts, **build_opts], resource)
    handle(result)
  end

  def destroy
    ssl = client(resource).ssl
    result = ssl.disable
    handle(result)
  end

  def exists?
    ssl = client(resource).ssl
    result = ssl.is_enabled

    result.data
  end
end
