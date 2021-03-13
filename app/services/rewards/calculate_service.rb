# frozen_string_literal: true

module Rewards
  class CalculateService
    POINT_FACTOR = 0.5

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

        add_history_or_scoring(referral_record)
      end
    end

    def add_history_or_scoring(record)
      case record[:action]
      when 'recommends'
        add_referral_history(record[:actor], record[:referee]) if record[:referee]
      when 'accepts'
        add_score(record[:actor], 0) if processed_sources.exclude?(record[:actor])
        processed_sources << record[:actor]
      end
    end

    def add_referral_history(actor, referee)
      unless referral_history[actor]
        referral_history[actor] = { referrer: nil, score: 0 }
      end
      referral_history[referee] = { referrer: actor, score: 0 }
      processed_referees << referee
    end

    def add_score(actor, power)
      referrer_key = referral_history.fetch(actor, {}).dig(:referrer)
      return unless referrer_key

      referrer = referral_history[referrer_key]
      referrer[:score] += POINT_FACTOR**power
      add_score(referrer_key, power + 1)
    end

    def sort_referrals
      Hash[referral_history.sort]
    end
  end
end
