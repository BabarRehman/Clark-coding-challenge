# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ParameterSanitizer
  include ReferralFilter
end
