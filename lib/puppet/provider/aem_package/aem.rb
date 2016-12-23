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

require_relative '../../../puppet_x/shinesolutions/puppet_aem_resources.rb'

Puppet::Type.type(:aem_package).provide(:aem, :parent => PuppetX::ShineSolutions::PuppetAemResources) do

  # Create a package.
  def create
    package = client().package(resource[:group], resource[:name], resource[:version])
    results = []
    opts = { force: resource[:force] }
    results.push(package.upload_wait_until_ready(resource[:path], opts))
    results.push(package.install_wait_until_ready())
    results.push(package.replicate()) if resource[:replicate] == true
    results.push(package.activate(true, false)) if resource[:activate] == true
    handle_multi(results)
  end

  # Delete the package.
  def destroy
    package = client().package(resource[:group], resource[:name], resource[:version])
    result = package.delete()
    handle(result)
  end

  # Check whether the package exists or not.
  # The definition of an existing package is one that is installed.
  def exists?
    package = client().package(resource[:group], resource[:name], resource[:version])
    package.is_installed().data
  end

end
