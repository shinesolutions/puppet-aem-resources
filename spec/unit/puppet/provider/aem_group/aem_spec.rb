# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_group provider: the ruby_aem calls it makes, with the ruby_aem client stubbed.
# Values are those of spec/acceptance/resources/44 and 45.
# Whether AEM creates the groups and memberships needs `make test-integration`.
describe Puppet::Type.type(:aem_group).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:group) { instance_double(RubyAem::Resources::Group) }
  let(:provider) { resource.provider }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
  end

  context 'with the 44 scenario for somegroup (present)' do
    let(:resource) { build_resource(:aem_group, 'Create group', ensure: 'present', name: 'somegroup', path: '/home/groups/s/') }

    before(:each) do
      allow(aem).to receive(:group).with('/home/groups/s/', 'somegroup').and_return(group)
    end

    it 'asks AEM whether the group exists' do
      allow(group).to receive(:exists).and_return(aem_result('Group somegroup not found', false))
      expect(provider.exists?).to be(false)
    end

    it 'only creates the group' do
      expect(group).not_to receive(:delete)
      expect(group).not_to receive(:add_member)
      expect(group).to receive(:create).and_return(aem_result('Group somegroup created'))
      provider.create
    end
  end

  context 'with the 44 scenario for staff (member group, force)' do
    let(:resource) do
      build_resource(:aem_group, 'Create staff group and add intern group as a member',
                     ensure: 'present', name: 'staff', path: '/home/groups/s',
                     member_group_name: 'intern', member_group_path: '/home/groups/i', force: true)
    end

    before(:each) do
      allow(aem).to receive(:group).with('/home/groups/s', 'staff').and_return(group)
    end

    it 'treats the group as missing without asking AEM' do
      expect(group).not_to receive(:exists)
      expect(provider.exists?).to be(false)
    end

    it 'deletes an existing group, then creates it and adds the member group' do
      expect(group).to receive(:exists).ordered.and_return(aem_result('Group staff exists', true))
      expect(group).to receive(:delete).ordered.and_return(aem_result('Group staff deleted'))
      expect(group).to receive(:create).ordered.and_return(aem_result('Group staff created'))
      expect(group).to receive(:add_member).with('intern').ordered.and_return(aem_result('Member intern added to group staff'))
      provider.create
    end
  end

  context 'with the 44 scenario for contractor (parent group, force)' do
    let(:resource) do
      build_resource(:aem_group, 'Create contractor group as a member of staff group',
                     ensure: 'present', name: 'contractor', path: '/home/groups/c',
                     parent_group_name: 'staff', parent_group_path: '/home/groups/s', force: true)
    end
    let(:parent_group) { instance_double(RubyAem::Resources::Group) }

    it 'creates the group and adds it to the parent group' do
      allow(aem).to receive(:group).with('/home/groups/c', 'contractor').and_return(group)
      allow(aem).to receive(:group).with('/home/groups/s', 'staff').and_return(parent_group)
      allow(group).to receive(:exists).and_return(aem_result('Group contractor not found', false))
      expect(group).not_to receive(:delete)
      expect(group).to receive(:create).ordered.and_return(aem_result('Group contractor created'))
      expect(parent_group).to receive(:add_member).with('contractor').ordered.and_return(aem_result('Member contractor added to group staff'))
      provider.create
    end
  end

  context 'with the 45 scenario (absent)' do
    let(:resource) { build_resource(:aem_group, 'Delete group', ensure: 'absent', name: 'somegroup', path: '/home/groups/s/') }

    it 'deletes the group' do
      allow(aem).to receive(:group).with('/home/groups/s/', 'somegroup').and_return(group)
      expect(group).to receive(:delete).and_return(aem_result('Group somegroup deleted'))
      provider.destroy
    end
  end
end
