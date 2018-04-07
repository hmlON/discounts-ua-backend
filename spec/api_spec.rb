require 'rspec_api_documentation/dsl'

RSpec.describe 'API' do
  let(:json) { response_body }

  resource 'Shops' do
    get '/api/shops' do
      before { DatabaseCleaner.clean_with(:truncation) }
      let!(:shops) { Fabricate.times(shops_count, :shop) }
      let(:shops_count) { 2 }

      before { do_request }
      example 'Receive a list of shops' do
        expect(status).to eq 200
        expect(json).to have_json_path('shops')
        expect(json).to have_json_size(shops_count).at_path('shops')
        Shop.all.each do |shop|
          expect(json).to include(shop.to_json)
        end
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
        expect(json).to have_json_size(discount_types_count).at_path('discount_types')
        expect(json).to have_json_size(discounts_count).at_path('discount_types/0/discounts')
      end
    end
  end
end
