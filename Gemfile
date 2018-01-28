source 'https://rubygems.org'

case RUBY_PLATFORM
when /darwin/
  gem 'CFPropertyList'
end

puppetversion = ENV['PUPPET_VERSION'] || '~> 4.0'
gem 'puppet', puppetversion, require: false

gem 'ruby_aem', '~> 1.4.1'

group :lint do
  gem 'puppet-lint', require: false
  gem 'rubocop', require: false
end
