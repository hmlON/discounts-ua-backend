RSpec.describe 'API', type: :controller do
  describe 'GET /api/discounts' do
    let!(:shops) { Fabricate.times(2, :shop) }
    before { get '/api/shops' }

    let(:json) { JSON.parse(last_response.body)['shops'] }
    let(:shops_count) { 2 }
    let(:shop_discount_types_count) { 4 }
    let(:discount_type_discounts_count) { 10 }

    it 'should return json with all active discounts' do
      expect(last_response.status).to eq 200
      expect(json.count).to eq shops_count
      expect(json[0]['discount_types'].count).to eq shop_discount_types_count
      expect(json[0]['discount_types'][0]['active_period']['discounts'].count).to eq discount_type_discounts_count
    end
  end
end
