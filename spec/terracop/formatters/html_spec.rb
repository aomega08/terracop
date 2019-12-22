# frozen_string_literal: true

require 'json'

RSpec.describe Terracop::Formatters::Html do
  it 'generates an HTML document with the offenses' do
    result = described_class.new.generate({})
    expect(result).to start_with '<!DOCTYPE html>'
  end
end
