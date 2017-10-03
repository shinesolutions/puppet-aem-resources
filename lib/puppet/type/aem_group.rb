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

Puppet::Type.newtype(:aem_group) do
  ensurable

  def self.title_patterns
    [[/^(.*)$/, [[:name, ->(x) { x }]]]]
  end

  newparam :name do
    isnamevar
    desc 'Group name'
    validate do |value|
      raise ArgumentError.new('Group name must be provided') if value == ''
    end
  end

  newparam :aem_id do
    isnamevar
    desc 'AEM instance ID'
  end

  newparam :path do
    desc 'Group path'
    validate do |value|
      raise ArgumentError.new('Group path must be provided') if value == ''
    end
  end

  newparam :parent_group_path do
    desc 'Parent group path'
  end

  newparam :parent_group_name do
    desc 'Parent group name'
  end

  newparam :member_group_path do
    desc 'Member group path'
  end

  newparam :member_group_name do
    desc 'Member group name'
  end

  newparam :force do
    desc 'Set to true to force group creation, if the group already exists then it will be deleted before recreated, default to false'
    validate do |value|
      value = false if value == ''
    end
  end
end
