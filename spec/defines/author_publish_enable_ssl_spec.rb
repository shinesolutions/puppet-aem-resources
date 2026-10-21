# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::author_publish_enable_ssl' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 42 jetty scenario parameters' do
        let(:title) { 'Enable author/publish SSL via Jetty' }
        let(:params) do
          {
            run_mode: 'author',
            aem_id: 'author',
            ssl_method: 'jetty',
            port: 5432,
            keystore: '/tmp/shinesolutions/puppet-aem-resources/aem.ks',
            keystore_password: 'somekeystorepassword',
            keystore_key_alias: 'cqse',
            truststore: '/tmp/shinesolutions/puppet-aem-resources/aem.ts',
            truststore_password: 'sometruststorepassword',
          }
        end

        it { is_expected.to compile.with_all_deps }
      end

      context 'with the 43 granite scenario parameters' do
        let(:title) { 'Enable author/publish SSL via Granite' }
        let(:params) do
          {
            run_mode: 'author',
            aem_id: 'author',
            ssl_method: 'granite',
            force: false,
            port: 5435,
            keystore: '/tmp/shinesolutions/puppet-aem-resources/cert_ssl.der',
            keystore_password: 'somekeystorepassword',
            truststore: '/tmp/shinesolutions/puppet-aem-resources/cert_ssl.crt',
            truststore_password: 'sometruststorepassword',
          }
        end

        it { is_expected.to compile.with_all_deps }
      end

      context 'with the 44 granite forced scenario parameters' do
        let(:title) { 'Enforce enabling author/publish SSL via Granite' }
        let(:params) do
          {
            run_mode: 'author',
            aem_id: 'author',
            ssl_method: 'granite',
            force: true,
            port: 5435,
            keystore: '/tmp/shinesolutions/puppet-aem-resources/cert_ssl.der',
            keystore_password: 'somekeystorepassword',
            truststore: '/tmp/shinesolutions/puppet-aem-resources/cert_ssl.crt',
            truststore_password: 'sometruststorepassword',
          }
        end

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
