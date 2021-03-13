# frozen_string_literal: true

class RewardsController < ApplicationController
  def index; end

  def calculate
    sanitized = sanitized_calculation_hash(params)

    if sanitized[:status] == :error
      return render json: { error: sanitized[:data] }
    end

    referrals = Rewards::CalculateService.call(data: sanitized[:data])

    clients = {}
    referrals.select { |_key, value| value[:score].positive? }.each do |key, value|
      clients[key] = value[:score]
    end
    render json: clients
  end
end
