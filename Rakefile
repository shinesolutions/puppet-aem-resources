# frozen_string_literal: true

require 'bundler'
require 'json'

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

# --- GitHub Changelog Generator ---
if Gem.loaded_specs.key? 'github_changelog_generator'
  require 'github_changelog_generator/task'

  def metadata
    @metadata ||= begin
      raise 'metadata.json not found' unless File.exist?('metadata.json')

      JSON.parse(File.read('metadata.json'))
    end
  end

  def changelog_user
    return unless Rake.application.top_level_tasks.include? 'changelog'

    # GitHub owner from the source URL, e.g. http://github.com/<user>/<project>
    source = metadata['source']
    match = source&.match(%r{.*\/([^\/]+)\/[^\/]+?(?:\.git)?\Z})
    user = match&.[](1)

    raise 'unable to calculate user from metadata.json' if user.nil?

    user
  end

  def changelog_project
    return unless Rake.application.top_level_tasks.include? 'changelog'

    source = metadata['source']
    match = source&.match(%r{.*\/([^\/]*?)(?:\.git)?\Z})
    project = match&.[](1)

    raise 'unable to calculate project from metadata.json' if project.nil?

    project
  end

  def changelog_future_release
    return unless Rake.application.top_level_tasks.include? 'changelog'

    version = metadata['version']
    raise 'unable to find version in metadata.json' if version.nil?

    version
  end

  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    if Rake.application.top_level_tasks.include?('changelog') && ENV['CHANGELOG_GITHUB_TOKEN'].nil?
      raise "Set CHANGELOG_GITHUB_TOKEN environment variable e.g. 'export CHANGELOG_GITHUB_TOKEN=valid_token_here'"
    end

    config.user = changelog_user
    config.project = changelog_project
    config.future_release = changelog_future_release
    config.exclude_labels = ['maintenance']
    config.header = "# Changelog\n\nAll notable changes to this project will be documented in this file.\n\n" \
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),\n" \
                    'and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).'
    config.add_pr_wo_labels = true
    config.issues = false
    config.merge_prefix = '### UNCATEGORIZED PRS; LABEL THEM ON GITHUB'
    config.configure_sections = {
      'Added'   => { 'prefix' => '### Added',   'labels' => ['enhancement', 'feature'] },
      'Changed' => { 'prefix' => '### Changed', 'labels' => ['backwards-incompatible'] },
      'Fixed'   => { 'prefix' => '### Fixed',   'labels' => ['bug', 'documentation', 'bugfix'] },
    }
  end
end