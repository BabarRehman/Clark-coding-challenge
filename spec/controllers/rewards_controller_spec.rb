# frozen_string_literal: true

require 'spec_helper'
RSpec.describe RewardsController do
  describe 'POST calculate' do
    let(:fixture_path) { Rails.root.join('spec/fixtures/files') }
    let(:params) { { referral_history: referral_history_file } }
    before do
      post :calculate, params: params
    end
    context 'without file it gives back an error' do
      let(:referral_history_file) { nil }

      it 'returns the status as 400' do
        expect(response.status).to eq(400)
      end

      it 'sends back the appropriate error message' do
        body = JSON.parse(response.body)

        expect(body).to eq({ 'error' => 'provided file is not processable' })
      end
    end

    context 'with file being empty' do
      let(:referral_history_file) { fixture_file_upload(fixture_path + 'empty.txt') }
      it 'returns the status as 400' do
        expect(response.status).to eq(400)
      end

      it 'sends back the appropriate error message' do
        body = JSON.parse(response.body)

        expect(body).to eq({ 'error' => 'provided file does not contain any data' })
      end
    end

    context 'with processable file' do
      let(:referral_history_file) { fixture_file_upload(fixture_path + 'perfect_input.txt') }

      it 'returns the status as 200' do
        expect(response.status).to eq(200)
      end

      it 'sends back the appropriate error message' do
        body = JSON.parse(response.body)

        expect(body).to eq({ 'A' => 1.75, 'B' => 1.5, 'C' => 1.0 })
      end
    end
  end
end
