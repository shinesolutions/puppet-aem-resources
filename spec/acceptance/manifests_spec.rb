require 'spec_helper_acceptance'

# The spec/acceptance/manifests scenarios that only manage files, so they run
# without an AEM instance. The other scenarios and spec/acceptance/resources
# call the AEM APIs and need a running AEM (see the test-integration Makefile target).
SCENARIOS_WITHOUT_AEM = [
  '09_set_osgi_config.pp',
  '10_author_primary_set_config_aem62.pp',
  '10_author_primary_set_config_aem63.pp',
  '10a_author_primary_set_config_aem62_with_multiple_runmodes.pp',
  '10a_author_primary_set_config_aem63_with_multiple_runmodes.pp',
  '10b_author_primary_set_config_aem62_with_multiple_runmodes_and_jvm_opts.pp',
  '10b_author_primary_set_config_aem63_with_multiple_runmodes_and_jvm_opts.pp',
  '11_author_standby_set_config_aem62.pp',
  '11_author_standby_set_config_aem63.pp',
  '11a_author_standby_promotion_aem62.pp',
  '11a_author_standby_promotion_aem63.pp',
  '11b_author_standby_set_config_aem62_with_multiple_runmodes.pp',
  '11b_author_standby_set_config_aem63_with_multiple_runmodes.pp',
  '11c_author_standby_promotion_aem62_with_multiple_runmodes.pp',
  '11c_author_standby_promotion_aem63_with_multiple_runmodes.pp',
  '12_publish_set_config.pp',
  '12a_publish_set_config_with_multiple_runmodes.pp',
  '12b_publish_set_config_with_multiple_runmodes_and_jvm_opts.pp',
  '15_author_dispatcher_set_config.pp',
  '16_publish_dispatcher_set_config.pp',
  '50_puppet_aem_resources_set_config.pp',
].freeze

# These scenarios use bstopp/aem, which calls the stdlib is_array and validate_re
# functions; stdlib 8 deprecates them, which fails the run with OpenVox's default
# strict = error, and stdlib 9 removed them
BSTOPP_AEM_FAILURE = 'bstopp/aem calls deprecated puppetlabs/stdlib functions, which fail with strict = error'.freeze

describe 'aem_resources scenarios' do
  SCENARIOS_WITHOUT_AEM.each do |scenario|
    context scenario do
      it 'works idempotently with no errors' do
        pending BSTOPP_AEM_FAILURE if scenario.start_with?('09_', '10', '11', '12')

        pp = File.read(File.join(__dir__, 'manifests', scenario))

        # Run it twice and test for idempotency
        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true)
      end
    end
  end
end
