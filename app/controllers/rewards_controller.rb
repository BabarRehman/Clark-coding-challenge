# frozen_string_literal: true

class RewardsController < ApplicationController
  def index; end

  def calculate
    sanitized = sanitized_calculation_hash(params)

    return render json: { error: sanitized[:data] }, status: 400 if sanitized[:status] == :error

    referrals = Rewards::CalculateService.call(data: sanitized[:data])
    render json: referees_score_card(referrals)
  end
end
