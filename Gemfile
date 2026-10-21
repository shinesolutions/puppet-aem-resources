source ENV['GEM_SOURCE'] || 'https://rubygems.org'

def location_for(place_or_version, fake_version = nil)
  git_url_regex = %r{\A(?<url>(https?|git)[:@][^#]*)(#(?<branch>.*))?}
  file_url_regex = %r{\Afile:\/\/(?<path>.*)}

  if place_or_version && (git_url = place_or_version.match(git_url_regex))
    [fake_version, { git: git_url[:url], branch: git_url[:branch], require: false }].compact
  elsif place_or_version && (file_url = place_or_version.match(file_url_regex))
    ['>= 0', { path: File.expand_path(file_url[:path]), require: false }]
  else
    [place_or_version, { require: false }]
  end
end

group :development, :test, :system_tests do
  # OpenVox 9 calls JSON.parse(string, options), which json 3 no longer accepts
  gem "json",                 "~> 2.21"
  gem "voxpupuli-test",       "~> 15.0", require: false
  gem "voxpupuli-acceptance", "~> 4.4",  require: false
  gem "voxpupuli-release",    "~> 5.5",  require: false
  # Loaded as a plugin in .rubocop.yml, not a dependency of voxpupuli-test
  gem "rubocop-performance",  "~> 1.27", require: false
end

# Used by the providers to call AEM
gem "ruby_aem", "4.1.0"

puppet_version = ENV['PUPPET_GEM_VERSION']
facter_version = ENV['FACTER_GEM_VERSION']
hiera_version  = ENV['HIERA_GEM_VERSION']

gems = {}
gems['puppet'] = location_for(puppet_version) if puppet_version
gems['facter'] = location_for(facter_version) if facter_version
gems['hiera']  = location_for(hiera_version)  if hiera_version

gems.each do |gem_name, gem_params|
  gem gem_name, *gem_params
end

extra_gemfiles = [
  "#{__FILE__}.local",
  File.join(Dir.home, '.gemfile'),
]

extra_gemfiles.each do |gemfile|
  if File.file?(gemfile) && File.readable?(gemfile)
    eval(File.read(gemfile), binding)
  end
end