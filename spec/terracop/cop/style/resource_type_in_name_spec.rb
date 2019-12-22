# frozen_string_literal: true

RSpec.describe Terracop::Cop::Style::ResourceTypeInName do
  subject(:cop) do
    described_class.new(type, resource_name, nil, {})
  end

  context 'with a blacklist for the resource' do
    let(:type) { 'aws_security_group' }

    context 'with a type hint in the name' do
      let(:resource_name) { 'my_app_sg' }

      it 'registers an offense' do
        expect_offense
      end
    end

    context 'with a proper name' do
      let(:resource_name) { 'my_app' }

      it 'does not register an offense' do
        expect_no_offenses
      end
    end
  end

  context 'with a resource missing a blacklist' do
    let(:type) { 'aws_my_special_resource' }

    context 'with any name' do
      let(:resource_name) { 'my_app' }

      it 'does not register an offense' do
        expect_no_offenses
      end
    end
  end
end
