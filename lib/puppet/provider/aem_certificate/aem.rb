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

require_relative '../../../puppet_x/shinesolutions/puppet_aem_resources.rb'
require 'tempfile'
require 'openssl'

Puppet::Type.type(:aem_certificate).provide(:aem, parent: PuppetX::ShineSolutions::PuppetAemResources) do
  # Archive a certificate from the AEM Truststore
  def archive
    return false if resource[:serial].nil?
    return false if resource[:file].nil?

    certificate = client(resource).certificate(resource[:serial])
    result = certificate.export(resource[:truststore_password])

    exported_certificate = result.data

    file = File.new(resource[:file], 'w')
    file.puts(exported_certificate)
    file.close
  end

  # Upload certificate to the AEM Truststore.
  def create
    return false if resource[:file].nil?

    certificate_raw = File.read resource[:file]
    certificate_infos = OpenSSL::X509::Certificate.new(certificate_raw)
    serial_number = certificate_infos.serial.to_i

    opts = {
      _retries: {
        max_tries: resource[:retries_max_tries],
        base_sleep_seconds: resource[:retries_base_sleep_seconds],
        max_sleep_seconds: resource[:retries_max_sleep_seconds]
      }
    }

    certificate = client(resource).certificate(serial_number)
    result = certificate.import_wait_until_ready(resource[:file], **opts)

    handle(result)
  end

  # Delete the certificate from the AEM Truststore.
  def destroy
    if resource[:serial]
      serial_number = resource[:serial]
    elsif resource[:file]
      certificate_raw = File.read resource[:file]
      certificate_infos = OpenSSL::X509::Certificate.new(certificate_raw)
      serial_number = certificate_infos.serial.to_i
    end

    return false if serial_number.nil?

    certificate = client(resource).certificate(serial_number)
    result = certificate.delete

    handle(result)
  end

  # Check if the certificate exists in the AEM Truststore.
  def exists?
    return false if resource[:force].eql? true

    if resource[:serial]
      serial_number = resource[:serial]
    elsif resource[:file]
      certificate_raw = File.read resource[:file]
      certificate_infos = OpenSSL::X509::Certificate.new(certificate_raw)
      serial_number = certificate_infos.serial.to_i
    end

    certificate = client(resource).certificate(serial_number)
    result = certificate.exists

    result.data
  end
end
