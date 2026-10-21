# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_user_alias provider, with the ruby_aem client stubbed. Only password_changed
# has real values: aem_resources::change_system_users_password as the spec/acceptance/manifests/22
# scenario declares it (force defaults to true). Whether AEM changes the password needs `make test-integration`.
describe Puppet::Type.type(:aem_user_alias).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:user) { instance_double(RubyAem::Resources::User) }
  let(:resource) do
    build_resource(:aem_user_alias, '[aem] Change user password - orchestrator',
                   ensure: 'password_changed', name: 'orchestrator', path: '/home/users/o',
                   old_password: 'customorchestratorpassword', new_password: 'neworchestratorpassword', force: true, aem_id: 'aem')
  end

  it 'logs in as the user with the old password and changes it' do
    expect(RubyAem::Aem).to receive(:new).with(hash_including(username: 'orchestrator', password: 'customorchestratorpassword')).and_return(aem)
    allow(aem).to receive(:user).with('/home/users/o', 'orchestrator').and_return(user)
    expect(user).to receive(:change_password).with('customorchestratorpassword', 'neworchestratorpassword')
                                             .and_return(aem_result('User orchestrator password changed'))
    resource.property(:ensure).sync
  end

  it 'treats the user as missing without asking AEM, as force is true' do
    expect(RubyAem::Aem).not_to receive(:new)
    expect(resource.provider.exists?).to be(false)
  end
end
