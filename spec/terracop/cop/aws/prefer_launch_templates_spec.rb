# frozen_string_literal: true

RSpec.describe Terracop::Cop::Aws::PreferLaunchTemplates do
  context 'when an aws_launch_configuration exists' do
    subject(:cop) do
      described_class.new('aws_launch_configuration', 'lc', nil, {})
    end

    it 'registers an offense' do
      expect_offense
    end
  end

  context 'with an aws_autoscaling_group' do
    subject(:cop) do
      described_class.new('aws_autoscaling_group', 'asg', nil, attributes)
    end

    context 'with a launch configuration' do
      let(:attributes) { { 'launch_configuration' => 'lc-123' } }

      it 'registers an offense' do
        expect_offense
      end
    end

    context 'without a launch configuration' do
      let(:attributes) { {} }

      it 'does not register an offense' do
        expect_no_offenses
      end
    end
  end
end
