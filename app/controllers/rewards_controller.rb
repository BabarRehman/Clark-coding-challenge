# frozen_string_literal: true

class RewardsController < ApplicationController
  def index; end

  def calculate
    sanitized = sanitized_calculation_hash(params)

    return render json: { error: sanitized[:data] } if sanitized[:status] == :error

    referrals = Rewards::CalculateService.call(data: sanitized[:data])

    clients = {}
    referrals.select { |_key, value| value[:score].positive? }.each do |key, value|
      clients[key] = value[:score]
    end
    render json: clients
  end
end
