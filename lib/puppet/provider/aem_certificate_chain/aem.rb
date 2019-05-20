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

Puppet::Type.type(:aem_certificate_chain).provide(:aem, parent: PuppetX::ShineSolutions::PuppetAemResources) do
  # Add a certificate chain to the AEM Keystore of a defined user.
  def create
    opts = {
      _retries: {
        max_tries: resource[:retries_max_tries],
        base_sleep_seconds: resource[:retries_base_sleep_seconds],
        max_sleep_seconds: resource[:retries_max_sleep_seconds]
      }
    }

    certificate_chain = client(resource).certificate_chain(resource[:private_key_alias], resource[:intermediate_path], resource[:authorizable_id])
    result = certificate_chain.import_wait_until_ready(resource[:certificate_chain_file_path], resource[:private_key_file_path], **opts)

    handle(result)
  end

  # Delete the AEM Keystore of a defined user.
  def destroy
    certificate_chain = client(resource).certificate_chain(resource[:private_key_alias], resource[:intermediate_path], resource[:authorizable_id])
    result = certificate_chain.delete

    handle(result)
  end

  # Check if the given private key alias name already exists in the AEM Keystore of a defined user.
  def exists?
    certificate_chain = client(resource).certificate_chain(resource[:private_key_alias], resource[:intermediate_path], resource[:authorizable_id])
    result = certificate_chain.exists

    result.data
  end
end
