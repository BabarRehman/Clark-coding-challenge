# frozen_string_literal: true

module ReferralFilter
  extend ActiveSupport::Concern

  def referees_score_card(referral_history)
    Hash[build_score_card(referral_history)]
  end

  private

  def build_score_card(referral_history)
    referral_history.select { |_referer, values| values[:score].positive? }
                    .map { |referer, values| score_card_entry(referer, values[:score]) }
  end

  def score_card_entry(referer, score)
    [referer, score]
  end
end
