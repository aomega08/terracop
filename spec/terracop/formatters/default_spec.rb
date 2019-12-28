# frozen_string_literal: true

RSpec.describe Terracop::Formatters::Default do
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

  let(:expected_output) do
    'aws_autoscaling_group.asg'.cyan + ":\n" +
      'Aws/PreferLaunchTemplates'.yellow +
      ": Prefer launch templates to launch configurations\n"
  end

  it 'generates a CLI friendly output' do
    result = described_class.new.generate(resources)
    expect(result).to eq expected_output
  end
end
