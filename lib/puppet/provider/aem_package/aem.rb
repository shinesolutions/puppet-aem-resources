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

require_relative '../../../puppet_x/shinesolutions/puppet_aem_resources'

Puppet::Type.type(:aem_package).provide(:aem, parent: PuppetX::ShineSolutions::PuppetAemResources) do
  # Archive a package by building a new package and downloading in to the specified path.
  # All older versions of the package that could've been built beforehand will be deleted before building the new package.
  def archive
    package = client(resource).package(resource[:group], resource[:name], resource[:version])
    results = []
    build_opts = {
      _retries: {
        max_tries: resource[:retries_max_tries],
        base_sleep_seconds: resource[:retries_base_sleep_seconds],
        max_sleep_seconds: resource[:retries_max_sleep_seconds]
      }
    }
    package.get_versions.data.each do |version|
      package_per_version = client(resource).package(resource[:group], resource[:name], version)
      results.push(package_per_version.delete_wait_until_ready) if package_per_version.exists.data == true
    end

    results.push(call_with_readiness_check(package, 'create', [], resource))
    results.push(call_with_readiness_check(package, 'update', [resource[:filter]], resource))
    results.push(call_with_readiness_check(package, 'build_wait_until_ready', [build_opts], resource))
    results.push(call_with_readiness_check(package, 'download', [resource[:path]], resource))

    handle_multi(results)
  end

  # Create a package.
  def create
    package = client(resource).package(resource[:group], resource[:name], resource[:version])
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

    results.push(call_with_readiness_check(package, 'upload_wait_until_ready', [resource[:path], upload_opts], resource))
    results.push(call_with_readiness_check(package, 'install_wait_until_ready', [install_opts], resource))
    results.push(call_with_readiness_check(package, 'replicate', [], resource)) if resource[:replicate] == true
    results.concat(call_with_readiness_check(package, 'activate_filter', [true, false], resource)) if resource[:activate] == true

    handle_multi(results)
  end

  # Delete the package.
  def destroy
    package = client(resource).package(resource[:group], resource[:name], resource[:version])
    results = []

    results.push(package.uninstall) if package.is_installed.data
    results.push(package.delete)

    handle_multi(results)
  end

  # Reinstall the package.
  def reinstall
    package = client(resource).package(resource[:group], resource[:name], resource[:version])
    results = []
    install_opts = {
      _retries: {
        max_tries: resource[:retries_max_tries],
        base_sleep_seconds: resource[:retries_base_sleep_seconds],
        max_sleep_seconds: resource[:retries_max_sleep_seconds]
      }
    }

    results.push(call_with_readiness_check(package, 'install_wait_until_ready', [install_opts], resource))
    results.push(call_with_readiness_check(package, 'replicate', [], resource)) if resource[:replicate] == true
    results.concat(call_with_readiness_check(package, 'activate_filter', [true, false], resource)) if resource[:activate] == true

    handle_multi(results)
  end

  # Check whether the package exists or not.
  # The definition of an existing package is one that is installed.
  # When force is set to true, package will be created if it doesn't exist or overwritten if it already exists.
  def exists?
    if resource[:force] == true
      false
    else
      package = client(resource).package(resource[:group], resource[:name], resource[:version])
      package.is_installed.data
    end
  end
end
