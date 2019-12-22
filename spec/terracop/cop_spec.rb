# frozen_string_literal: true

RSpec.describe Terracop::Cop do
  describe '.run_for' do
    it 'returns all the offences for a given resource' do
      issues = described_class.run_for(
        'aws_my_special_resource', 'dashed-name', nil, {}
      )

      expect(issues[0][:cop_name]).to eq 'Style/DashInResourceName'
    end
  end
end
