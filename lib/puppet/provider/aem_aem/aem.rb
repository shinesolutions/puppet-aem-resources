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

Puppet::Type.type(:aem_aem).provide(:aem, :parent => PuppetX::ShineSolutions::PuppetAemResources) do

  # Get the login page and wait until it's ready.
  # This is handy when AEM restarts Jetty and the next operation needs to wait.
  def get_login_page_wait_until_ready
    opts = {
      _retries: {
        max_tries: resource[:retries_max_tries],
        base_sleep_seconds: resource[:retries_base_sleep_seconds],
        max_sleep_seconds: resource[:retries_max_sleep_seconds],
      }
    }
    client().aem().get_login_page_wait_until_ready(opts)
  end

  # Existence check defaults to true in order to simulate that aem always exists.
  def exists?
    true
  end

end
