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
                  :processed_targets,
                  :referral_history

    def initialize(params)
      self.referral_records = params[:data]
      self.processed_sources = []
      self.processed_targets = []
      self.referral_history = {}
    end

    def calculate
      referral_records.each do |referral_record|
        next if processed_targets.include?(referral_record[:referred])

        add_history_or_scoring(referral_record)
      end
    end

    def add_history_or_scoring(record)
      case record[:action]
      when 'recommends'
        add_referral_history(record[:actor], record[:referred]) if record[:referred]
      when 'accepts'
        add_score(record[:actor], 0) if processed_sources.exclude?(record[:actor])
        processed_sources << record[:actor]
      end
    end

    def add_referral_history(actor, referred)
      referral_history[referred] = { referrer: actor, score: 0 }
      unless referral_history[actor]
        referral_history[actor] = { referrer: nil, score: 0 }
      end
      processed_targets << referred
    end

    def add_score(actor, power)
      referral_history.select { |key, _v| key == actor }.each do |_key, value|
        referrer_key = value[:referrer]
        break unless referrer_key

        referrer = referral_history[referrer_key]
        referrer[:score] += POINT_FACTOR**power
        add_score(referrer_key, power + 1)
      end
    end

    def sort_referrals
      Hash[referral_history.sort]
    end
  end
end
