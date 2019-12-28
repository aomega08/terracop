# frozen_string_literal: true

RSpec.describe Terracop::Runner do
  let(:state_file) { File.join(__dir__, '..', 'support', 'state.json') }
  let(:plan_file) { File.join(__dir__, '..', 'support', 'plan.json') }

  context 'with a state file' do
    subject(:runner) { described_class.new(:state, state_file, :json) }

    let(:expected_state) do
      [
        {
          type: 'aws_iam_group',
          name: 'my-group',
          index: nil,
          attributes: {
            'arn' => 'arn:aws:iam::000111222333:group/my_group',
            'id' => 'my_group',
            'name' => 'my_group',
            'path' => '/',
            'unique_id' => 'AAAAA0AAAAA0AAAAAAAAA'
          }
        }
      ]
    end

    it 'loads the state' do
      expect(runner.state).to eq expected_state
    end

    it 'returns the number of offenses' do
      expect(runner.run).to eq 1
    end
  end

  context 'with no state file' do
    subject(:runner) { described_class.new(:state, nil, :json) }

    it 'tries to load the state from the terraform context' do
      allow(runner).to receive(:load_state_from_terraform)
      runner.state

      expect(runner).to have_received(:load_state_from_terraform)
    end
  end

  context 'with a plan file' do
    subject(:runner) { described_class.new(:plan, state_file, :json) }

    let(:plan) { JSON.parse(File.read(plan_file)) }
    let(:expected_state) do
      [
        {
          name: 'users',
          type: 'aws_iam_user',
          index: 'joe.schmo',
          attributes: {
            'arn' => 'arn:aws:iam::000111222333:user/joe.schmo',
            'force_destroy' => false,
            'id' => 'joe.schmo',
            'name' => 'joe.schmo',
            'path' => '/',
            'permissions_boundary' => nil,
            'tags' => {
              'Email' => 'joe.schmo@email.com'
            },
            'unique_id' => 'AAAAAAAAAAAAAAAAAAAAA'
          }
        },
        {
          name: 'users',
          type: 'aws_iam_user',
          index: 'jane.doe',
          attributes: {
            'force_destroy' => false,
            'name' => 'jane.doe',
            'path' => '/',
            'permissions_boundary' => nil,
            'tags' => {}
          }
        }
      ]
    end

    before do
      allow(Terracop::PlanLoader).to receive(:decode).and_return(plan)
    end

    it 'loads the state, ignoring deletes and no-op' do
      expect(runner.state).to eq expected_state
    end

    it 'returns the number of offenses' do
      expect(runner.run).to eq 1
    end
  end
end
