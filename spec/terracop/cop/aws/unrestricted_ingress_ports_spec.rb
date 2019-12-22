# frozen_string_literal: true

RSpec.describe Terracop::Cop::Aws::UnrestrictedIngressPorts do
  subject(:cop) do
    described_class.new('aws_security_group_rule', 'rule', nil, attributes)
  end

  context 'with an ingress rule allowing traffic on any TCP or UDP port' do
    let(:attributes) do
      {
        'type' => 'ingress',
        'from_port' => 0,
        'to_port' => 65_535,
        'protocol' => 'udp'
      }
    end

    it 'registers an offense' do
      expect_offense
    end

    context 'with any more specific rule' do
      let(:attributes) do
        {
          'type' => 'ingress',
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
