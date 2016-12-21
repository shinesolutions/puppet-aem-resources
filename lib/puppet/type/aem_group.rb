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

Puppet::Type.newtype(:aem_group)do

  ensurable

  newparam :name, :namevar => false do
    desc 'Group name'
    validate do |value|
      fail 'Group name must be provided' if value == ''
    end
  end

  newparam :path do
    desc 'Group path'
    validate do |value|
      fail 'Group path must be provided' if value == ''
    end
  end

end
