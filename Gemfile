source 'https://rubygems.org'

case RUBY_PLATFORM
when /darwin/
  gem 'CFPropertyList'
end

if puppetversion = ENV['PUPPET_VERSION']
  gem 'puppet', puppetversion, require: false
else
  gem 'puppet', "~> 4.0", require: false
end

gem 'nokogiri', '~> 1.6.8.1'
gem 'rubocop', require: false
gem 'ruby_aem', '~> 1.3.0'

group :lint do
  gem 'puppet-lint', require: false
end
