# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_aem provider's readiness ensure values: which ruby_aem wait it calls and the
# retry options it passes, with the ruby_aem client stubbed. Values are those of
# spec/acceptance/resources/00, 01, 01b and 01c. Whether AEM gets ready needs a running AEM:
# see `make test-integration`.
describe Puppet::Type.type(:aem_aem).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:aem_instance) { instance_double(RubyAem::Resources::Aem) }
  let(:retries) { { max_tries: 60, base_sleep_seconds: 5, max_sleep_seconds: 5 } }
  let(:retry_params) { { retries_max_tries: 60, retries_base_sleep_seconds: 5, retries_max_sleep_seconds: 5 } }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
    allow(aem).to receive(:aem).and_return(aem_instance)
  end

  context 'with the 00 scenario (aem_health_check_is_ok)' do
    let(:resource) do
      build_resource(:aem_aem, 'Wait until health is ok',
                     ensure: 'aem_health_check_is_ok', tags: 'shallow', combine_tags_or: false, **retry_params)
    end

    it 'waits until the AEM health check is OK, with the tags and retries' do
      expect(aem_instance).to receive(:get_aem_health_check_wait_until_ok).with({ tags: 'shallow', combine_tags_or: false, _retries: retries })
                                                                          .and_return(aem_result('AEM health check is OK'))
      resource.property(:ensure).sync
    end

    it 'fails the resource when AEM is not healthy after the retries' do
      allow(aem_instance).to receive(:get_aem_health_check_wait_until_ok).and_raise(StandardError, 'AEM health check is not OK')
      expect { resource.property(:ensure).sync }.to raise_error(Puppet::ResourceError, %r{AEM health check is not OK})
    end

    it 'always reports AEM as present, so the wait runs on every Puppet run' do
      expect(resource.provider.exists?).to be(true)
    end
  end

  context 'with the 01 scenario (login_page_is_ready)' do
    let(:resource) { build_resource(:aem_aem, 'Wait until login page is ready', ensure: 'login_page_is_ready', **retry_params) }

    it 'waits until the login page is ready, with the retries' do
      expect(aem_instance).to receive(:get_login_page_wait_until_ready).with({ _retries: retries }).and_return(aem_result('Login page ready'))
      resource.property(:ensure).sync
    end
  end

  context 'with the 01b scenario (install_status_is_finished)' do
    let(:resource) { build_resource(:aem_aem, 'Wait until install status is finished', ensure: 'install_status_is_finished', **retry_params) }

    it 'waits until the install status is finished, with the retries' do
      expect(aem_instance).to receive(:get_install_status_wait_until_finished).with({ _retries: retries }).and_return(aem_result('Install status finished'))
      resource.property(:ensure).sync
    end
  end

  context 'with the 01c scenario (aem_package_manager_is_ready)' do
    let(:resource) { build_resource(:aem_aem, 'Wait until CRX Package Manager is ready', ensure: 'aem_package_manager_is_ready', **retry_params) }

    it 'waits until the Package Manager is ready, with the retries' do
      expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with({ _retries: retries })
                                                                                           .and_return(aem_result('Package Manager ready'))
      resource.property(:ensure).sync
    end
  end
end
