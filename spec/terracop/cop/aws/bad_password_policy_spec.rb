# frozen_string_literal: true

RSpec.describe Terracop::Cop::Aws::BadPasswordPolicy do
  subject(:cop) do
    described_class.new('aws_iam_account_password_policy', 'rule', nil,
                        good_attributes.merge(attributes))
  end

  let(:good_attributes) do
    {
      'require_lowercase_characters' => true,
      'require_uppercase_characters' => true,
      'require_numbers' => true,
      'require_symbols' => true,
      'minimum_password_length' => 30
    }
  end

  context 'with a good password policy' do
    let(:attributes) { {} }

    it 'does not register an offense' do
      expect_no_offenses
    end
  end

  context 'with a short password length' do
    let(:attributes) { { 'minimum_password_length' => 8 } }

    it 'registers an offense' do
      expect_offense
    end
  end

  context 'with a short password expiration window' do
    let(:attributes) { { 'max_password_age' => 7 } }

    it 'registers an offense' do
      expect_offense
    end
  end

  context 'when uppercase characters are not required' do
    let(:attributes) { { 'require_uppercase_characters' => false } }

    it 'registers an offense' do
      expect_offense
    end
  end

  context 'when lowercase characters are not required' do
    let(:attributes) { { 'require_lowercase_characters' => false } }

    it 'registers an offense' do
      expect_offense
    end
  end

  context 'when numbers are not required' do
    let(:attributes) { { 'require_numbers' => false } }

    it 'registers an offense' do
      expect_offense
    end
  end

  context 'when symbols are not required' do
    let(:attributes) { { 'require_symbols' => false } }

    it 'registers an offense' do
      expect_offense
    end
  end
end
