# frozen_string_literal: true

module Support
  module ReferralHistory
    HASH = { A: { referrer: nil, score: 1.75 },
             B: { referrer: 'A', score: 1.5 },
             C: { referrer: 'B', score: 1.0 },
             D: { referrer: 'C', score: 0 } }.freeze
  end
end
