# frozen_string_literal: true

RSpec.describe Terracop::Cop::Aws::OpenSsh do
  subject(:cop) do
    described_class.new('aws_security_group_rule', 'rule', nil, attributes)
  end

  context 'with an ingress rule allowing traffic from 0.0.0.0/0' do
    context 'when the rule allows TCP port 22' do
      let(:attributes) do
        {
          'type' => 'ingress',
          'cidr_blocks' => ['0.0.0.0/0'],
          'from_port' => 20,
          'to_port' => 25,
          'protocol' => 'tcp'
        }
      end

      it 'registers an offense' do
        expect_offense
      end
    end

    context 'when the rule does not affect port 22' do
      let(:attributes) do
        {
          'type' => 'ingress',
          'cidr_blocks' => ['0.0.0.0/0'],
          'from_port' => 1000,
          'to_port' => 1001,
          'protocol' => 'tcp'
        }
      end

      it 'does not register an offense' do
        expect_no_offenses
      end
    end
  end
end
