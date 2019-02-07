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

Puppet::Type.type(:aem_truststore).provide(:aem, parent: PuppetX::ShineSolutions::PuppetAemResources) do
  # Archive a AEM Truststore by downloading in to the specified path.
  def archive
    file_path = resource[:file] if resource[:file]
    file_path = "#{resource[:path]}/truststore.p12" if resource[:path]
    return false if file_path.nil?

    truststore = client(resource).truststore
    result = truststore.download(file_path)

    handle(result)
  end

  # Create the AEM Truststore.
  def create
    truststore = client(resource).truststore
    if resource[:file] || resource[:path]
      opts = {
        _retries: {
          max_tries: resource[:retries_max_tries],
          base_sleep_seconds: resource[:retries_base_sleep_seconds],
          max_sleep_seconds: resource[:retries_max_sleep_seconds]
        }
      }

      file_path = resource[:file] if resource[:file]
      file_path = "#{resource[:path]}/truststore.p12" if resource[:path]
      opts[:force] = resource[:force]
      result = truststore.upload_wait_until_ready(file_path, **opts)
    else
      result = truststore.create(resource[:password])
    end

    handle(result)
  end

  # Delete the AEM Truststore.
  def destroy
    truststore = client(resource).truststore
    result = truststore.delete

    handle(result)
  end

  # Check if the AEM Truststore exists
  def exists?
    return true if resource[:force] && resource[:ensure] == :absent
    return false if resource[:force] && resource[:ensure] == :present

    truststore = client(resource).truststore
    result = truststore.exists

    result.data
  end
end
