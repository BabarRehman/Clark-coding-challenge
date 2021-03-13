# frozen_string_literal: true

require 'spec_helper'
require 'support/missing_referred'
require 'support/referred_accepts_twice'
require 'support/sanitized_calculation'
require 'support/starts_with_acceptance'

RSpec.describe Rewards::CalculateService do
  include Support::MissingReferred
  include Support::ReferredAcceptsTwice
  include Support::SanitizedCalculation
  include Support::StartsWithAcceptance

  subject(:make_call) { described_class.call(params) }

  let(:sanitized_input) { Support::SanitizedCalculation::SANITIZED_HASH }
  let(:starts_with_acceptance) { Support::StartsWithAcceptance::SANITIZED_HASH }
  let(:missing_referred) { Support::MissingReferred::SANITIZED_HASH }
  let(:referred_accepts_twice) { Support::ReferredAcceptsTwice::SANITIZED_HASH }
  let(:params) { { data: sanitized_input } }

  describe 'call' do
    context 'when perfectly formatted input' do
      it 'returns calculated referrers which have a positive score' do
        expect(make_call).to eq('A' => { parent: nil, score: 1.75 },
                                'B' => { parent: 'A', score: 1.5 },
                                'C' => { parent: 'B', score: 1.0 },
                                'D' => { parent: 'C', score: 0 })
      end
    end

    context 'with not perfectly formatted input' do
      context 'when the data has acceptance without any recommendation' do
        let(:params) { { data: starts_with_acceptance } }
        it 'does not contribute to any scoring' do
          expect(make_call).to eq('A' => { parent: nil, score: 1.75 },
                                  'B' => { parent: 'A', score: 1.5 },
                                  'C' => { parent: 'B', score: 1.0 },
                                  'D' => { parent: 'C', score: 0 })
        end
      end

      context 'when recommendation does not have a referred' do
        let(:params) { { data: missing_referred } }
        it 'is not considered, and is not added to the constructed history' do
          expect(make_call).to eq('A' => { parent: nil, score: 1.75 },
                                  'B' => { parent: 'A', score: 1.5 },
                                  'C' => { parent: 'B', score: 1.0 },
                                  'D' => { parent: 'C', score: 0 })
        end
      end

      context 'when a referred accepts twice' do
        let(:params) { { data: referred_accepts_twice } }
        it 'is considered only once in scoring' do
          expect(make_call).to eq('A' => { parent: nil, score: 1.75 },
                                  'B' => { parent: 'A', score: 1.5 },
                                  'C' => { parent: 'B', score: 1.0 },
                                  'D' => { parent: 'C', score: 0 })
        end
      end
    end
  end
end
