# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_user provider: the ruby_aem calls it makes and their arguments, with the
# ruby_aem client stubbed. Values are those of spec/acceptance/resources/40, 41, 42, 43 and 46.
# Whether AEM accepts these calls needs a running AEM: see `make test-integration`.
describe Puppet::Type.type(:aem_user).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:user) { instance_double(RubyAem::Resources::User) }
  let(:provider) { resource.provider }
  let(:no_permissions) { ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', 'replicate:false'] }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
  end

  context 'with the 40 scenario for bob (present, group, permissions, force)' do
    let(:resource) do
      build_resource(:aem_user, 'Create user bob and add to administrators group',
                     ensure: 'present', name: 'bob', path: '/home/users/b', password: 'somepassword',
                     group_name: 'administrators', group_path: '/home/groups/a',
                     permission: { '/libs' => no_permissions, '/var' => no_permissions, '/tmp' => no_permissions }, force: true)
    end

    before(:each) do
      allow(aem).to receive(:user).with('/home/users/b', 'bob').and_return(user)
    end

    it 'treats the user as missing without asking AEM' do
      expect(user).not_to receive(:exists)
      expect(provider.exists?).to be(false)
    end

    it 'deletes an existing user, then creates it, adds it to the group and sets each permission' do
      permission_csv = 'read:false,modify:false,create:false,delete:false,acl_read:false,acl_edit:false,replicate:false'
      expect(user).to receive(:exists).ordered.and_return(aem_result('User bob exists', true))
      expect(user).to receive(:delete).ordered.and_return(aem_result('User bob deleted'))
      expect(user).to receive(:create).with('somepassword').ordered.and_return(aem_result('User bob created'))
      expect(user).to receive(:add_to_group).with('/home/groups/a', 'administrators').ordered.and_return(aem_result('User bob added to group'))
      ['/libs', '/var', '/tmp'].each do |permission_path|
        expect(user).to receive(:set_permission).with(permission_path, permission_csv).ordered.and_return(aem_result("Permission set on #{permission_path}"))
      end
      provider.create
    end

    it 'does not delete the user first when it does not exist' do
      allow(user).to receive(:exists).and_return(aem_result('User bob not found', false))
      allow(user).to receive_messages(create: aem_result('created'), add_to_group: aem_result('added'), set_permission: aem_result('set'))
      expect(user).not_to receive(:delete)
      provider.create
    end
  end

  context 'with the 40 scenario for charlie (present, no group)' do
    let(:resource) do
      build_resource(:aem_user, 'Create user charlie without any group',
                     ensure: 'present', name: 'charlie', path: '/home/users/c', password: 'somepassword')
    end

    before(:each) do
      allow(aem).to receive(:user).with('/home/users/c', 'charlie').and_return(user)
    end

    it 'asks AEM whether the user exists' do
      allow(user).to receive(:exists).and_return(aem_result('User charlie not found', false))
      expect(provider.exists?).to be(false)
    end

    it 'only creates the user' do
      expect(user).to receive(:create).with('somepassword').and_return(aem_result('User charlie created'))
      expect(user).not_to receive(:add_to_group)
      expect(user).not_to receive(:set_permission)
      provider.create
    end
  end

  context 'with the 41 scenario (password_changed)' do
    let(:resource) do
      build_resource(:aem_user, 'Change user bob password',
                     ensure: 'password_changed', name: 'bob', path: '/home/users/b',
                     old_password: 'somepassword', new_password: 'somenewpassword')
    end

    it 'logs in as the user with the old password and changes it' do
      expect(RubyAem::Aem).to receive(:new).with(hash_including(username: 'bob', password: 'somepassword')).and_return(aem)
      allow(aem).to receive(:user).with('/home/users/b', 'bob').and_return(user)
      expect(user).to receive(:change_password).with('somepassword', 'somenewpassword').and_return(aem_result('User bob password changed'))
      resource.property(:ensure).sync
    end
  end

  context 'with the 42 scenario (added_to_group)' do
    let(:resource) do
      build_resource(:aem_user, 'Add user charlie to administrators group',
                     ensure: 'added_to_group', name: 'charlie', path: '/home/users/c',
                     group_name: 'administrators', group_path: '/home/groups/a')
    end

    it 'adds the user to the group' do
      allow(aem).to receive(:user).with('/home/users/c', 'charlie').and_return(user)
      expect(user).to receive(:add_to_group).with('/home/groups/a', 'administrators').and_return(aem_result('User charlie added to group'))
      resource.property(:ensure).sync
    end
  end

  context 'with the 43 scenario (absent)' do
    let(:resource) { build_resource(:aem_user, 'Delete user bob', ensure: 'absent', name: 'bob', path: '/home/users/b') }

    it 'deletes the user' do
      allow(aem).to receive(:user).with('/home/users/b', 'bob').and_return(user)
      expect(user).to receive(:delete).and_return(aem_result('User bob deleted'))
      provider.destroy
    end
  end

  context 'with the 46 scenario (has_permission)' do
    let(:resource) do
      build_resource(:aem_user, 'Update replication-service user permission',
                     ensure: 'has_permission', name: 'replication-service', path: '/home/users/system/',
                     permission: { '/etc/replication/agents.author' => ['replicate:false'], '/etc/replication/agents.publish' => ['replicate:false'] })
    end

    it 'sets each permission' do
      allow(aem).to receive(:user).with('/home/users/system/', 'replication-service').and_return(user)
      expect(user).to receive(:set_permission).with('/etc/replication/agents.author', 'replicate:false').and_return(aem_result('set'))
      expect(user).to receive(:set_permission).with('/etc/replication/agents.publish', 'replicate:false').and_return(aem_result('set'))
      resource.property(:ensure).sync
    end
  end
end
