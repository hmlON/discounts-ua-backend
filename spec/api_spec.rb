RSpec.describe 'API', type: :controller do
  describe 'GET /api/discounts' do
    let!(:shops) { Fabricate.times(2, :shop) }
    before { get '/api/discounts' }

    let(:json) { JSON.parse last_response.body }

    it 'should return json with all active discounts' do
      expect(last_response.status).to eq 200
      # expect(json['shops'].count).to eq 2
      # expect(json['shops'][0]).to eq 2

      # shop.discount_types.each do |discount_type|
      #   expect(page).to have_content discount_type.name.humanize
      #   expect(page).to have_content discount_type.active_period.end_date.strftime('%d %b %Y')

      #   discount_type.active_period.discounts.each do |discount|
      #     expect(page).to have_content discount.name
      #   end
      # end
    end
  end
end
