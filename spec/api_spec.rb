RSpec.describe 'API', type: :controller do
  describe 'GET /api/shops' do
    let!(:shops) do
      Shop.destroy_all
      Fabricate.times(2, :shop)
    end
    subject! { get '/api/shops' }

    let(:json) { JSON.parse(last_response.body)['shops'] }
    let(:shops_count) { 2 }

    it 'should return json with all active discounts' do
      expect(last_response.status).to eq 200
      expect(json.count).to eq shops_count
      expect(json[0]['slug']).to eq Shop.first.slug
    end
  end

  describe 'GET /api/shops/:shop' do
    let(:slug) { 'shopik' }
    let!(:shops) { Fabricate(:shop, slug: slug) }
    subject! { get "/api/shops/#{slug}" }

    let(:json) { JSON.parse(last_response.body) }
    let(:discount_types_count) { 4 }
    let(:discounts_count) { 10 }

    it 'should return json with all active discounts' do
      expect(last_response.status).to eq 200
      expect(json['discount_types'].count).to eq discount_types_count
      expect(json['discount_types'][0]['active_period']['discounts'].count).to eq discounts_count
    end
  end
end
