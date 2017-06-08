source 'https://rubygems.org'

case RUBY_PLATFORM
when /darwin/
  gem 'CFPropertyList'
end

gem 'nokogiri', '~> 1.6.8.1'
gem 'puppet', require: false
gem 'rubocop', require: false
gem 'ruby_aem', '~> 1.3.0'

group :lint do
  gem 'puppet-lint', require: false
end
