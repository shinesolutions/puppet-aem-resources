# frozen_string_literal: true

require 'bundler'

# --- Vox Pupuli Rake Tasks ---
# Automatically provides: syntax, lint, rubocop, spec, test, strings:generate
require 'voxpupuli/test/rake'

# --- Vox Pupuli Release Tasks ---
# Provides: module:build (packages the module into pkg/), module:*, release
begin
  require 'voxpupuli/release/rake_tasks'
rescue LoadError
  # Safe to rescue if the development group is omitted
end

begin
  require 'voxpupuli/acceptance/rake'
rescue LoadError
  # Safe to rescue if system_tests group is omitted during unit tests
end
