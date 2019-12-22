# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter 'spec'
end

require 'bundler/setup'
require 'terracop'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  def expect_offense
    subject.check
    expect(subject.offenses).not_to be_empty
  end

  def expect_no_offenses
    subject.check
    expect(subject.offenses).to be_empty
  end
end
