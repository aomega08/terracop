# frozen_string_literal: true

require 'json'

RSpec.describe Terracop::Formatters::Json do
  it 'generates a JSON with the offenses' do
    result = described_class.new.generate({})
    data = JSON.parse(result)

    expect(data['resources']).to eq []
  end
end
