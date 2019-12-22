# frozen_string_literal: true

RSpec.describe Terracop::Cop::Aws::WideIngress do
  subject(:cop) do
    described_class.new('aws_security_group_rule', 'rule', nil, attributes)
  end

  let(:attributes) do
    {
      'type' => type,
      'cidr_blocks' => [cidr_block]
    }
  end

  context 'with an egress rule' do
    let(:type) { 'egress' }
    let(:cidr_block) { '10.0.0.0/8' }

    it 'ignores it' do
      expect_no_offenses
    end
  end

  context 'with an ingress rule' do
    let(:type) { 'ingress' }

    context 'with a CIDR to 0.0.0.0/0' do
      let(:cidr_block) { '0.0.0.0/0' }

      it 'ignores it' do
        # This case would be handled by OpenEgress
        expect_no_offenses
      end
    end

    context 'with a CIDR allowing traffic from large blocks' do
      let(:cidr_block) { '10.0.0.0/8' }

      it 'registers an offense' do
        expect_offense
      end
    end

    context 'with only CIDRs allowing traffic from smaller blocks' do
      let(:cidr_block) { '1.2.3.0/24' }

      it 'does not register an offense' do
        expect_no_offenses
      end
    end
  end
end
