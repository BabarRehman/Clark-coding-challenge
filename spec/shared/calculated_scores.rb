# frozen_string_literal: true

RSpec.shared_examples 'calculated scores' do
  it 'returns calculated referrers which have a positive score' do
    expect(make_call).to eq('A' => { parent: nil, score: 1.75 },
                            'B' => { parent: 'A', score: 1.5 },
                            'C' => { parent: 'B', score: 1.0 },
                            'D' => { parent: 'C', score: 0 })
  end
end
