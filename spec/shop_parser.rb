RSpec.describe ATB do
  before(:each) do
    Shop.create_all
  end

  describe '.economy' do
    xit 'parses' do
      VCR.use_cassette('atb_economy', record: :new_episodes) do
        expect { ATB.economy }.to change { Discount.count }
      end
    end
  end
end
