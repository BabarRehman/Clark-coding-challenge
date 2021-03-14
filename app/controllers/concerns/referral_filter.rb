# frozen_string_literal: true

# Transforms the input(referral history) into the final output of "referrer: score". It filters
# out referrers whose score is 0. It also allows the output of Rewards::CalculateService to be used
# in more use cases as that withholds more information.
# input:
# {"A"=>{:referrer=>nil, :score=>1.5},
#  "B"=>{:referrer=>"A", :score=>1.0},
#  "C"=>{:referrer=>"B", :score=>0}}
# output:
# {"A"=>1.5,
#  "B"=>1.0}
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
