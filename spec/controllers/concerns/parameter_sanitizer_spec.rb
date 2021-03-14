# frozen_string_literal: true

require 'spec_helper'
require 'shared/empty_file'
require 'shared/successful_transformation'
require 'support/sanitized_calculation'

RSpec.describe ParameterSanitizer do
  include ParameterSanitizer
  include Support::SanitizedCalculation
  subject(:sanitized_data) { sanitized_calculation_hash(params) }
  let(:fixture_path) { Rails.root.join('spec/fixtures/files') }
  let(:referral_history_file) { fixture_file_upload(fixture_path + 'perfect_input.txt') }
  let(:params) { { referral_history: referral_history_file } }
  let(:expected_output) { Support::SanitizedCalculation::SANITIZED_HASH }

  describe 'sanitized_calculation_hash' do
    context 'when the file is readable' do
      context 'when file has no empty lines' do
        it_behaves_like 'successful transformation'
      end

      context 'when file has empty lines along with data' do
        let(:referral_history_file) do
          fixture_file_upload(fixture_path + 'input_with_empty_lines.txt')
        end

        it_behaves_like 'successful transformation'
      end

      context 'when file is empty' do
        let(:referral_history_file) { fixture_file_upload(fixture_path + 'empty.txt') }

        it_behaves_like 'empty file'
      end

      context 'when file has all empty lines' do
        let(:referral_history_file) { fixture_file_upload(fixture_path + 'input_with_all_empty_lines.txt') }

        it_behaves_like 'empty file'
      end
    end

    context 'when the file is not readable' do
      let(:referral_history_file) { nil }

      describe 'status' do
        it 'is error' do
          expect(sanitized_data[:status]).to eq(:error)
        end
      end

      describe 'data' do
        it 'is the error message' do
          expect(sanitized_data[:data]).to eq('provided file is not processable')
        end
      end
    end
  end
end
