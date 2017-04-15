RSpec.describe Silpo do
  before(:each) do
    Shop.create_all
  end

  describe '.price_of_the_week' do
    it 'parses' do
      VCR.use_cassette('silpo_price_of_the_week') do
        expect { Silpo.price_of_the_week }.to change { Discount.count }
      end
    end
  end

  describe '.hot_proposal' do
    it 'parses' do
      VCR.use_cassette('silpo_hot_proposal') do
        expect { Silpo.price_of_the_week }.to change { Discount.count }
      end
    end
  end
end
