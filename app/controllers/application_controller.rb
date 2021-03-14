# frozen_string_literal: true

# Included the modules in application controller so that if sharing is required they will be readily
# available.
class ApplicationController < ActionController::Base
  include ParameterSanitizer
  include ReferralFilter
end
