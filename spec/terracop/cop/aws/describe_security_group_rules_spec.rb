# frozen_string_literal: true

RSpec.describe Terracop::Cop::Aws::DescribeSecurityGroupRules do
  subject(:cop) do
    described_class.new('aws_security_group_rule', 'rule', nil, attributes)
  end

  context 'with no description for the rule' do
    let(:attributes) { { 'description' => '' } }

    it 'registers an offense' do
      expect_offense
    end
  end

  context 'with a description' do
    let(:attributes) { { 'description' => 'allow this and that' } }

    it 'does not register an offense' do
      expect_no_offenses
    end
  end
end
