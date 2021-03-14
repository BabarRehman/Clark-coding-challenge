# frozen_string_literal: true

module ParameterSanitizer
  extend ActiveSupport::Concern

  def sanitized_calculation_hash(params)
    file = params.dig(:calculation, :referral_history)

    if file.respond_to?(:read)
      readable_response(file)
    else
      unreadable_response
    end
  end

  private

  def readable_response(file)
    records = read_file(file)

    return empty_response if records.blank?

    successful_response(records)
  end

  def empty_response
    error_response('provided file does not contain any data')
  end

  def unreadable_response
    error_response('provided file is not processable')
  end

  def successful_response(data)
    response(data, :success)
  end

  def error_response(message)
    response(message, :error)
  end

  def response(data, status)
    { status: status, data: data }
  end

  def read_file(file)
    [].tap do |records|
      file.open.each_line do |line|
        attributes = line.split(' ')
        next if attributes.blank?

        records << build_record(attributes)
      end
    end
  end

  def build_record(attributes)
    { date: attributes[0],
      time: attributes[1],
      actor: attributes[2],
      action: attributes[3],
      referee: attributes[4] }
  end
end
