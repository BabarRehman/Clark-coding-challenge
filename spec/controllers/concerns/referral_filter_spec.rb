# frozen_string_literal: true

require 'spec_helper'
require 'support/referral_history'

RSpec.describe ReferralFilter do
  include ReferralFilter
  include Support::ReferralHistory

  subject(:score_card) { referees_score_card(history) }

  let(:history) { Support::ReferralHistory::HASH }

  describe 'referees_score_card' do
    context 'when history has values with score 0' do
      it 'filters them out' do
        expect(score_card).to eq({ A: 1.75, B: 1.5, C: 1.0 })
      end
    end
  end
end
