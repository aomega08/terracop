# frozen_string_literal: true

RSpec.describe Terracop::Cop::Aws::EnsurePropagatedTags do
  subject(:cop) do
    described_class.new('aws_autoscaling_group', 'asg', nil, attributes)
  end

  let(:config) do
    { 'Enabled' => true }
  end

  before do
    allow(described_class).to receive(:config) { config }
  end

  context 'when the resource allows for tags' do
    context 'with no tags' do
      let(:attributes) { { 'tags' => [] } }

      it 'registers an offense' do
        expect_offense
      end
    end

    context 'with some tags' do
      context 'when no tags are marked as required' do
        let(:attributes) do
          {
            'tags' => [
              {
                'key' => 'hello',
                'value' => 'world',
                'propagate_at_launch' => true
              }
            ]
          }
        end

        it 'does not register an offense' do
          expect_no_offenses
        end
      end

      context 'when some tags are marked as required' do
        let(:config) { { 'Enabled' => true, 'Required' => ['Test'] } }

        context 'when the required tag is defined' do
          let(:attributes) do
            {
              'tags' => [
                {
                  'key' => 'Test',
                  'value' => 'abc',
                  'propagate_at_launch' => true
                }
              ]
            }
          end

          it 'does not register an offense' do
            expect_no_offenses
          end
        end

        context 'when the required tag is missing' do
          let(:attributes) do
            {
              'tags' => [
                {
                  'key' => 'hello',
                  'value' => 'world',
                  'propagate_at_launch' => true
                }
              ]
            }
          end

          it 'registers an offense' do
            expect_offense
          end
        end
      end
    end
  end
end
