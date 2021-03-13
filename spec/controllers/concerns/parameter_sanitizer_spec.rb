# frozen_string_literal: true

require 'spec_helper'
require 'support/sanitized_calculation'
RSpec.describe ParameterSanitizer do
  include ParameterSanitizer
  include Support::SanitizedCalculation
  subject(:sanitized_data) { sanitized_calculation_hash(params) }

  let(:referral_history) { Tempfile.new('foo').tap { |f| f << content } }
  let(:params) { { calculation: { referral_history: referral_history } } }
  let(:expected_output) { Support::SanitizedCalculation::SANITIZED_HASH }

  let(:content) do
    "2018-06-12 09:41 A recommends B\n
    2018-06-14 09:41 B accepts\n
    2018-06-16 09:41 B recommends C\n
    2018-06-17 09:41 C accepts\n
    2018-06-19 09:41 C recommends D\n
    2018-06-23 09:41 B recommends D\n
    2018-06-25 09:41 D accepts"
  end

  describe 'sanitized_calculation_hash' do
    context 'when the file is readable' do
      describe 'status' do
        it 'is success' do
          expect(sanitized_data[:status]).to eq(:success)
        end
      end

      describe 'data' do
        it 'is the mapped_hash' do
          expect(sanitized_data[:data]).to eq(expected_output)
        end
      end

      context 'when file is empty' do
        let(:content) { '' }

        describe 'status' do
          it 'is error' do
            expect(sanitized_data[:status]).to eq(:error)
          end
        end

        describe 'data' do
          it 'is the error message' do
            expect(sanitized_data[:data]).to eq('provided file does not contain any data')
          end
        end
      end

      context 'when file has empty lines' do
        let(:content) { "  \n  \n  \n" }

        describe 'status' do
          it 'is error' do
            expect(sanitized_data[:status]).to eq(:error)
          end
        end

        describe 'data' do
          it 'is the error message' do
            expect(sanitized_data[:data]).to eq('provided file does not contain any data')
          end
        end
      end

      context 'when file has empty lines along with data' do
        let(:content) do
          "2018-06-12 09:41 A recommends B\n
           2018-06-14 09:41 B accepts\n
           2018-06-16 09:41 B recommends C\n
           2018-06-17 09:41 C accepts\n

           2018-06-19 09:41 C recommends D\n
           2018-06-23 09:41 B recommends D\n
           2018-06-25 09:41 D accepts"
        end
        describe 'status' do
          it 'is success' do
            expect(sanitized_data[:status]).to eq(:success)
          end
        end

        describe 'data' do
          it 'is the mapped_hash' do
            expect(sanitized_data[:data]).to eq(expected_output)
          end
        end
      end
    end

    context 'when the file is not readable' do
      let(:referral_history) { nil }

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
