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

require_relative '../../../puppet_x/shinesolutions/puppet_aem_resources.rb'

Puppet::Type.type(:aem_package).provide(:aem, parent: PuppetX::ShineSolutions::PuppetAemResources) do
  # Archive a package by building a new package and downloading in to the specified path.
  # All older versions of the package that could've been built beforehand will be deleted before building the new package.
  def archive
    package = client(aem_id: resource[:aem_id]).package(resource[:group], resource[:name], resource[:version])
    results = []
    build_opts = {
      _retries: {
        max_tries: resource[:retries_max_tries],
        base_sleep_seconds: resource[:retries_base_sleep_seconds],
        max_sleep_seconds: resource[:retries_max_sleep_seconds]
      }
    }
    package.get_versions.data.each do |version|
      package_per_version = client(aem_id: resource[:aem_id]).package(resource[:group], resource[:name], version)
      results.push(package_per_version.delete_wait_until_ready) if package_per_version.exists.data == true
    end
    results.push(package.create)
    results.push(package.update(resource[:filter]))
    results.push(package.build_wait_until_ready(build_opts))
    results.push(package.download(resource[:path]))
    handle_multi(results)
  end

  # Create a package.
  def create
    package = client(aem_id: resource[:aem_id]).package(resource[:group], resource[:name], resource[:version])
    results = []
    upload_opts = {
      force: resource[:force],
      _retries: {
        max_tries: resource[:retries_max_tries],
        base_sleep_seconds: resource[:retries_base_sleep_seconds],
        max_sleep_seconds: resource[:retries_max_sleep_seconds]
      }
    }
    install_opts = {
      _retries: {
        max_tries: resource[:retries_max_tries],
        base_sleep_seconds: resource[:retries_base_sleep_seconds],
        max_sleep_seconds: resource[:retries_max_sleep_seconds]
      }
    }
    results.push(package.upload_wait_until_ready(resource[:path], upload_opts))
    results.push(package.install_wait_until_ready(install_opts))
    results.push(package.replicate) if resource[:replicate] == true
    results = results.concat(package.activate_filter(true, false)) if resource[:activate] == true
    handle_multi(results)
  end

  # Delete the package.
  def destroy
    package = client(aem_id: resource[:aem_id]).package(resource[:group], resource[:name], resource[:version])
    results = []
    results.push(package.uninstall) if package.is_installed.data
    results.push(package.delete)
    handle_multi(results)
  end

  # Check whether the package exists or not.
  # The definition of an existing package is one that is installed.
  # When force is set to true, package will be created if it doesn't exist or overwritten if it already exists.
  def exists?
    if resource[:force] == true
      false
    else
      package = client(aem_id: resource[:aem_id]).package(resource[:group], resource[:name], resource[:version])
      package.is_installed.data
    end
  end
end
