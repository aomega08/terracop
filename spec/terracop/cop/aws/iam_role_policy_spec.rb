# frozen_string_literal: true

RSpec.describe Terracop::Cop::Aws::IamRolePolicy do
  subject(:cop) do
    described_class.new('aws_iam_role_policy', 'inline', nil, {})
  end

  context 'when an aws_iam_role_policy exists' do
    it 'registers an offense' do
      expect_offense
    end
  end
end
