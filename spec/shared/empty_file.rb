# frozen_string_literal: true

RSpec.shared_examples 'empty file' do
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
