# frozen_string_literal: true

RSpec.shared_examples 'successful transformation' do
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
