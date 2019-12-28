# frozen_string_literal: true

RSpec.describe Terracop::Cop::Aws::FaultIntolerant do
  subject(:cop) do
    described_class.new('aws_autoscaling_group', 'asg', nil, attributes)
  end

  context 'with less than two AZs' do
    let(:attributes) { { 'availability_zones' => [ 'eu-west-1a'] } }

    it 'registers an offense' do
      expect_offense
    end
  end

  context 'with more than one AZ' do
    let(:attributes) do
      {
        'availability_zones' => ['eu-west-1a', 'eu-west-1b']
      }
    end

    it 'does not register an offense' do
      expect_no_offenses
    end
  end
end
