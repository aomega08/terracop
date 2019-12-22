# frozen_string_literal: true

RSpec.describe Terracop::Cop::Style::DashInResourceName do
  subject(:cop) { described_class.new('aws_res', resource_name, nil, {}) }

  context 'with a dash in the name' do
    let(:resource_name) { 'my-resource' }

    it 'registers an offense' do
      expect_offense
    end
  end

  context 'without dashes in the name' do
    let(:resource_name) { 'my_resource' }

    it 'does not register an offense' do
      expect_no_offenses
    end
  end
end
