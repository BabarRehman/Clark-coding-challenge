# frozen_string_literal: true

module Rewards
  # The brain of the application. It accepts the input, creates a hash of the history for correct
  # records and increments the score by the formula (1/2)^n where n being degree of separation from
  # the recommender in recommendation chain. n starts from 0 for direct recommender and increments
  # up the chain. It ensures that among multiple referrals to the same referee only the first one
  # gets credit in case of referee acceptance. Any acceptances without a recommender, double
  # acceptances, and recommendations without referee (all possible errors in input) are handled.
  # in input file)
  #
  # input:
  # { :data=>
  #   [{:actor=>"A",
  #     :action=>"recommends",
  #     :referee=>"B"},
  #    {:actor=>"B",
  #     :action=>"accepts",
  #     :referee=>nil},
  #    {:actor=>"B",
  #     :action=>"recommends",
  #     :referee=>"C"},
  #    {:actor=>"C",
  #     :action=>"accepts",
  #     :referee=>nil}]  }
  # output:
  # {"A"=>{:referrer=>nil, :score=>1.5},
  #  "B"=>{:referrer=>"A", :score=>1.0},
  #  "C"=>{:referrer=>"B", :score=>0}}
  class CalculateService
    POINTS_FACTOR = 0.5

    def self.call(params)
      new(params).call
    end

    def call
      calculate
      sort_referrals
    end

    private

    attr_accessor :referral_records,
                  :processed_sources,
                  :processed_referees,
                  :referral_history

    def initialize(params)
      self.referral_records = params[:data]
      self.processed_sources = []
      self.processed_referees = []
      self.referral_history = {}
    end

    def calculate
      referral_records.each do |referral_record|
        next if processed_referees.include?(referral_record[:referee])

        add_history_or_score(referral_record)
      end
    end

    def add_history_or_score(record)
      case record[:action]
      when 'recommends'
        add_referral_history(record[:actor], record[:referee]) if record[:referee]
      when 'accepts'
        add_score(record[:actor], 0) if processed_sources.exclude?(record[:actor])
        processed_sources << record[:actor]
      end
    end

    def add_referral_history(actor, referee)
      referral_history[actor] = { referrer: nil, score: 0 } unless referral_history[actor]
      referral_history[referee] = { referrer: actor, score: 0 }
      processed_referees << referee
    end

    def add_score(actor, power)
      referrer_key = referral_history.fetch(actor, {})[:referrer]
      return unless referrer_key

      referrer = referral_history[referrer_key]
      referrer[:score] += POINTS_FACTOR**power
      add_score(referrer_key, power + 1)
    end

    def sort_referrals
      Hash[referral_history.sort]
    end
  end
end
