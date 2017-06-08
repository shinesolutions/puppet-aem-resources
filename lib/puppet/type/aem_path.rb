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

Puppet::Type.newtype(:aem_path) do
  ensurable do
    newvalue(:is_activated) do
      provider.activate
    end
  end

  newparam :name, namevar: false do
    desc 'AEM path name'
    validate do |value|
      raise ArgumentError.new('AEM path name must be provided') if value == ''
    end
  end
end
