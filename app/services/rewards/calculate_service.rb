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

    attr_accessor :data, :processed_sources, :processed_targets, :referral_history

    def initialize(params)
      self.data = params[:data]
      self.processed_sources = []
      self.processed_targets = []
      self.referral_history = {}
    end

    def calculate
      data.each do |referral_record|
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

    def add_referral_history(source, target)
      referral_history[target] = { parent: source, score: 0 }
      unless referral_history[source]
        referral_history[source] = { parent: nil, score: 0 }
      end
      processed_targets << target
    end

    def add_score(source_key, power)
      referral_history.select { |key, _v| key == source_key }.each do |_key, value|
        parent_key = value[:parent]
        return unless parent_key # next to make rubocop happy

        parent = referral_history[parent_key]
        parent[:score] += POINT_FACTOR**power
        add_score(parent_key, power + 1)
      end
    end

    def sort_referrals
      Hash[referral_history.sort]
    end
  end
end
