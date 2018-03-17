require 'rspec_api_documentation/dsl'

RSpec.describe 'API' do
  let(:json) { JSON.parse(response_body) }

  resource 'Shops' do
    get '/api/shops' do
      before { DatabaseCleaner.clean_with(:truncation) }
      let!(:shops) { Fabricate.times(shops_count, :shop) }
      let(:shops_count) { 2 }

      before { do_request }
      example 'Receive a list of shops' do
        expect(status).to eq 200
        expect(json['shops'].count).to eq shops_count
        expect(json['shops'][0]['slug']).to eq Shop.first.slug
      end
    end

    get '/api/shops/:slug' do
      let(:slug) { 'shopik' }
      let!(:shop) { Fabricate(:shop, slug: slug) }
      let(:discount_types_count) { 4 }
      let(:discounts_count) { 10 }

      before { do_request }

      example 'Receive a single shop' do
        expect(status).to eq 200
        expect(json['discount_types'].count).to eq discount_types_count
        expect(json['discount_types'][0]['discounts'].count).to eq discounts_count
      end
    end
  end
end
