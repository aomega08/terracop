# frozen_string_literal: true

RSpec.describe Terracop::Cop::Aws::IamPolicyAttachment do
  subject(:cop) do
    described_class.new('aws_iam_policy_attachment', 'attach', nil, {})
  end

  context 'when an aws_iam_policy_attachment exists' do
    it 'registers an offense' do
      expect_offense
    end
  end
end
