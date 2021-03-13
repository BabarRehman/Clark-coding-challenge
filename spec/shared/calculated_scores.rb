# frozen_string_literal: true

RSpec.shared_examples 'calculated scores' do
  it 'returns calculated referrers which have a positive score' do
    expect(make_call).to eq('A' => { referrer: nil, score: 1.75 },
                            'B' => { referrer: 'A', score: 1.5 },
                            'C' => { referrer: 'B', score: 1.0 },
                            'D' => { referrer: 'C', score: 0 })
  end
end
