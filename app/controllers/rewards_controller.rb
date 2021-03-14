# frozen_string_literal: true

# Powers the app.
class RewardsController < ApplicationController
  # Since sending the referral history is being done with text file, the index makes the task
  # interaction easier
  def index; end

  # The endpoint for the task. accepts plain text files and return a json response
  def calculate
    sanitized = sanitized_calculation_hash(params)

    return render json: { error: sanitized[:data] }, status: 400 if sanitized[:status] == :error

    referrals = Rewards::CalculateService.call(data: sanitized[:data])
    render json: referees_score_card(referrals)
  end
end
