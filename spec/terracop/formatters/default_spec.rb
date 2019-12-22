# frozen_string_literal: true

RSpec.describe Terracop::Formatters::Default do
  it 'generates a CLI friendly output' do
    result = described_class.new.generate({})
    expect(result).to be_empty
  end
end
