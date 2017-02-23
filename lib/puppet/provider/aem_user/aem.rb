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

Puppet::Type.type(:aem_user).provide(:aem, :parent => PuppetX::ShineSolutions::PuppetAemResources) do

  # Create a user.
  def create
    user = client().user(resource[:path], resource[:name])
    result = user.create(resource[:password])
    handle(result)
  end

  # Delete the user.
  def destroy
    user = client().user(resource[:path], resource[:name])
    result = user.delete()
    handle(result)
  end

  # Check whether the user exists or not.
  def exists?
    user = client().user(resource[:path], resource[:name])
    user.exists().data
  end

  def change_password
    user = client({ username: resource[:name], password: resource[:old_password] }).user(resource[:path], resource[:name])
    result = user.change_password(resource[:old_password], resource[:new_password])
    handle(result)
  end

end
