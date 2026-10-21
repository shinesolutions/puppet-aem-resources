require 'beaker_puppet_helpers'
require 'voxpupuli/acceptance/spec_helper_acceptance'

# beaker_puppet_helpers has no repo install step for Amazon Linux, although the
# OpenVox yum repo publishes <collection>-release-amazon-<version>.noarch.rpm
module AmazonReleaseRepo
  def install_puppet_release_repo_on(host, collection = 'puppet')
    variant, version, = host['packaging_platform'].split('-', 3)
    return super unless variant == 'amazon'

    repos = BeakerPuppetHelpers::InstallUtils::REPOS[implementation_from_collection(collection).to_sym][:release]
    host.install_package("#{repos[:yum]}/#{collection}-release-amazon-#{version}.noarch.rpm")
  end
end
BeakerPuppetHelpers::InstallUtils.singleton_class.prepend(AmazonReleaseRepo)

# Directory the spec/acceptance/manifests scenarios use for their AEM files
TEST_DIR = '/tmp/shinesolutions/puppet-aem-resources'.freeze

# configure_beaker installs the local module (and its metadata.json dependencies)
# on each host in before(:suite), then runs this block
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
