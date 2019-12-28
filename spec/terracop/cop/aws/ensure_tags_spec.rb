# frozen_string_literal: true

RSpec.describe Terracop::Cop::Aws::EnsureTags do
  subject(:cop) { described_class.new('any', 'res', nil, attributes) }

  let(:config) do
    { 'Enabled' => true }
  end

  before do
    allow(described_class).to receive(:config) { config }
  end

  context 'when the resource allows for tags' do
    context 'with no tags' do
      let(:attributes) { { 'tags' => {} } }

      it 'registers an offense' do
        expect_offense
      end
    end

    context 'with some tags' do
      context 'when no tags are marked as required' do
        let(:attributes) { { 'tags' => { 'hello' => 'world' } } }

        it 'does not register an offense' do
          expect_no_offenses
        end
      end

      context 'when some tags are marked as required' do
        let(:config) { { 'Enabled' => true, 'Required' => ['Test'] } }

        context 'when the required tag is defined' do
          let(:attributes) { { 'tags' => { 'Test' => 'abc' } } }

          it 'does not register an offense' do
            expect_no_offenses
          end
        end

        context 'when the required tag is missing' do
          let(:attributes) { { 'tags' => { 'hello' => 'world' } } }

          it 'registers an offense' do
            expect_offense
          end
        end
      end
    end
  end

  context 'when the resource is an autoscaling group' do
    subject(:cop) do
      described_class.new('aws_autoscaling_group', 'res', nil, attributes)
    end

    let(:config) { { 'Enabled' => true, 'Required' => ['tag'] } }

    context 'with defined "tag"' do
      let(:attributes) do
        {
          'tag' => [
            {
              'key' => 'tag',
              'value' => 'value'
            }
          ]
        }
      end

      it 'does not register an offense' do
        expect_no_offenses
      end
    end

    context 'with defined "tags"' do
      let(:attributes) do
        {
          'tags' => [
            {
              'key' => 'tag',
              'value' => 'value'
            }
          ]
        }
      end

      it 'does not register an offense' do
        expect_no_offenses
      end
    end
  end

  context 'when the resource cannot have tags' do
    let(:attributes) { {} }

    it 'does not register an offense' do
      expect_no_offenses
    end
  end
end
