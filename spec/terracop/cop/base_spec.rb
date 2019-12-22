# frozen_string_literal: true

class MockCop < Terracop::Cop::Base
end

RSpec.describe Terracop::Cop::Base do
  it 'does not run a cop that is not enabled' do
    allow(MockCop).to receive(:enabled?).and_return(false)

    expect(MockCop.run('resource', 'name', 0, {})).to be_nil
  end

  it 'raises an exception when a cop does not define the #check method' do
    expect { MockCop.run('resource', 'name', 0, {}) }
      .to raise_error(NotImplementedError)
  end

  it 'does not run a cop on a resource that matches its exclusion list' do
    allow(MockCop).to receive(:config).and_return(
      'Enabled' => true,
      'Exclude' => ['type.*', 'resource.name']
    )

    expect(MockCop.run('resource', 'name', 0, {})).to be_nil
  end

  describe '#human_name' do
    context 'without an index' do
      it 'generates a terraform-like human name for a resource' do
        cop = MockCop.new('resource', 'name', nil, {})
        expect(cop.human_name).to eq 'name'
      end
    end

    context 'with an index' do
      it 'generates a terraform-like human name for a resource' do
        cop = MockCop.new('resource', 'name', 0, {})
        expect(cop.human_name).to eq 'name[0]'
      end
    end
  end
end
