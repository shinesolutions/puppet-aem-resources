source 'https://rubygems.org'

case RUBY_PLATFORM
when /darwin/
  gem 'CFPropertyList'
end

puppetversion = ENV['PUPPET_VERSION'] || '~> 4.0'
gem 'puppet', puppetversion, require: false

gem 'nokogiri', '~> 1.6.8.1'
gem 'rubocop', require: false
gem 'ruby_aem', '~> 1.4.0'

group :lint do
  gem 'puppet-lint', require: false
end
