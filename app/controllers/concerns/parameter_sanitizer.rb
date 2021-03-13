# frozen_string_literal: true

module ParameterSanitizer
  extend ActiveSupport::Concern

  def sanitized_calculation_hash(params)
    file_data = params.dig(:calculation, :referral_history)

    status = :success

    if file_data.respond_to?(:read)
      data = read_file(file_data)
    else
      status = :error
      data = 'provided file is not processable'
    end

    if data.blank?
      status = :error
      data = 'provided file does not contain any data'
    end

    { status: status, data: data }
  end

  private

  def read_file(file)
    [].tap do |data|
      file.open.each_line do |line|
        line_data = line.split(' ')
        next if line_data.blank?

        data << build_data(line_data)
      end
    end
  end

  def build_data(attributes)
    { date: attributes[0],
      time: attributes[1],
      referrer: attributes[2],
      action: attributes[3],
      referred: attributes[4] }
  end
end
