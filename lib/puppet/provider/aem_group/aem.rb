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

Puppet::Type.type(:aem_group).provide(:aem, :parent => PuppetX::ShineSolutions::PuppetAemResources) do

  # Create a group.
  def create
    group = client().group(resource[:path], resource[:name])
    result = group.create()
    handle(result)
  end

  # Delete the group.
  def destroy
    group = client().group(resource[:path], resource[:name])
    result = group.delete()
    handle(result)
  end

  # Check whether the group exists or not.
  def exists?
    group = client().group(resource[:path], resource[:name])
    group.exists().data
  end

end
