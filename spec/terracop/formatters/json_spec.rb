# frozen_string_literal: true

require 'json'

RSpec.describe Terracop::Formatters::Json do
  let(:resources) do
    {
      'aws_autoscaling_group.asg' => [
        {
          cop_name: 'Aws/PreferLaunchTemplates',
          message: 'Prefer launch templates to launch configurations',
          severity: 'convention'
        }
      ]
    }
  end

  let(:expected_resources) do
    [
      {
        'resource' => 'aws_autoscaling_group.asg',
        'offsenses' => [
          {
            'cop_name' => 'Aws/PreferLaunchTemplates',
            'message' => 'Prefer launch templates to launch configurations',
            'severity' => 'convention'
          }
        ]
      }
    ]
  end

  it 'generates a JSON with the offenses' do
    result = described_class.new.generate(resources)
    data = JSON.parse(result)

    expect(data['resources']).to eq expected_resources
  end
end
