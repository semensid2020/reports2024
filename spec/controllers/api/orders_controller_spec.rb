require 'rails_helper'

RSpec.describe Api::OrdersController, type: :controller do
  shared_examples 'returns correct JSON structure and data' do
    it 'returns a successful JSON response' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct JSON structure and data' do
      json_response = response.parsed_body

      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(order_data.size)

      json_response.each_with_index do |record, index|
        expect(record['month']).to eq(order_data[index][:month].strftime('%Y-%m'))
        expect(record['total_amount'].to_f).to eq(order_data[index][:total_amount].to_f)
      end
    end
  end

  describe 'GET #last_year_by_months' do
    context 'with mock data' do
      let!(:order_data) do
        (0..14).map do |months_ago|
          month = Time.zone.now - months_ago.months
          { month: month.beginning_of_month, total_amount: (months_ago + 1) * 1000.00 }
        end
      end

      before do
        allow(Order).to receive(:sum_by_month_within_last_year).and_return(order_data)
        get :last_year_by_months, format: :json
      end

      it_behaves_like 'returns correct JSON structure and data'
    end

    context 'with real data' do
      before do
        (0..14).each do |months_ago|
          travel_to Time.zone.now - months_ago.months do
            create_list(:order, 20, amount: 100.00)
          end
        end

        travel_to 1.year.ago do
          create(:order, amount: 500.00)
        end

        travel_back
        get :last_year_by_months, format: :json
      end

      let!(:order_data) do
        Order.within_last_year
             .select("DATE_TRUNC('month', created_at) AS month, SUM(amount) AS total_amount")
             .group("DATE_TRUNC('month', created_at)")
             .order('month DESC')
             .map { |record| { month: record.month, total_amount: record.total_amount.to_f } }
      end

      it_behaves_like 'returns correct JSON structure and data'
    end

    context 'with no orders' do
      before do
        Order.delete_all
        get :last_year_by_months, format: :json
      end

      it 'returns a successful JSON response' do
        expect(response).to have_http_status(:success)
      end

      it 'returns an empty array when there are no orders' do
        expect(response.parsed_body).to eq([])
      end
    end
  end
end
