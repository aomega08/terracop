# frozen_string_literal: true

RSpec.describe Terracop::Cop::Aws::OpenEgress do
  subject(:cop) do
    described_class.new('aws_security_group_rule', 'rule', nil, attributes)
  end

  context 'with an egress rule allowing traffic from 0.0.0.0/0' do
    let(:attributes) { { 'type' => 'egress', 'cidr_blocks' => ['0.0.0.0/0'] } }

    it 'registers an offense' do
      expect_offense
    end
  end

  context 'without an egress rule allowing traffic from 0.0.0.0/0' do
    let(:attributes) { { 'type' => 'egress', 'cidr_blocks' => ['1.2.3.4/32'] } }

    it 'does not register an offense' do
      expect_no_offenses
    end
  end
end
