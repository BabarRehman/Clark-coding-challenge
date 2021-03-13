# frozen_string_literal: true

require 'spec_helper'
require 'shared/calculated_scores'
require 'support/missing_referee'
require 'support/referee_accepts_twice'
require 'support/sanitized_calculation'
require 'support/starts_with_acceptance'

RSpec.describe Rewards::CalculateService do
  include Support::MissingReferee
  include Support::RefereeAcceptsTwice
  include Support::SanitizedCalculation
  include Support::StartsWithAcceptance

  subject(:make_call) { described_class.call(params) }

  let(:sanitized_input) { Support::SanitizedCalculation::SANITIZED_HASH }
  let(:starts_with_acceptance) { Support::StartsWithAcceptance::SANITIZED_HASH }
  let(:missing_referred) { Support::MissingReferee::SANITIZED_HASH }
  let(:referred_accepts_twice) { Support::RefereeAcceptsTwice::SANITIZED_HASH }
  let(:params) { { data: sanitized_input } }

  describe 'call' do
    context 'when perfectly formatted input' do
      it_behaves_like 'calculated scores'
    end

    context 'with not perfectly formatted input' do
      context 'when the data has acceptance without any recommendation' do
        let(:params) { { data: starts_with_acceptance } }
        it_behaves_like 'calculated scores'
      end

      context 'when recommendation does not have a referred' do
        let(:params) { { data: missing_referred } }
        it_behaves_like 'calculated scores'
      end

      context 'when a referred accepts twice' do
        let(:params) { { data: referred_accepts_twice } }
        it_behaves_like 'calculated scores'
      end
    end
  end
end
