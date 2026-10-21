# frozen_string_literal: true

require 'spec_helper'

describe 'aem_resources' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults for all parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('aem_resources') }
      end
    end
  end
end
