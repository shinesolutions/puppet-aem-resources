require 'voxpupuli/acceptance/spec_helper_acceptance'

# Directory the spec/acceptance/manifests scenarios use for their AEM files
TEST_DIR = '/tmp/shinesolutions/puppet-aem-resources'.freeze

# configure_beaker installs the local module (and its metadata.json dependencies)
# on each host in before(:suite), then runs this block. The agent comes from the
# nodesets' images (BEAKER_PUPPET_COLLECTION=preinstalled in the Makefile)
configure_beaker do |host|
  # Set up the scenario fixtures, as the test-integration Makefile target does
  on host, 'useradd aem || echo "User might already exist"'
  on host, "mkdir -p #{TEST_DIR}/author/somepackagegroup/somepackage/1.2.3/"
  Dir.glob(File.join(__dir__, 'acceptance', 'fixtures', '*')).each do |fixture|
    scp_to host, fixture, "#{TEST_DIR}/#{File.basename(fixture)}"
  end
  on host, "cp #{TEST_DIR}/somepackage-1.2.3.zip #{TEST_DIR}/author/somepackagegroup/"
  ['author-primary-6.2', 'author-primary-6.3', 'author-standby-6.2', 'author-standby-6.3', 'publish'].each do |instance|
    on host, "mkdir -p #{TEST_DIR}/#{instance}/crx-quickstart/bin/ #{TEST_DIR}/#{instance}/crx-quickstart/install/"
    on host, "cp #{TEST_DIR}/start-env #{TEST_DIR}/start #{TEST_DIR}/#{instance}/crx-quickstart/bin/"
  end
end
