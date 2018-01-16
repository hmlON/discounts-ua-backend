RSpec.describe DiscountTypeParser do
  let(:config) {
    {
      name: 'myshop',
      url: 'https://myshop.ua',
      discount_types: [
        {
          name: 'good discounts',
          path: '/discounts/good',
          discounts_xpath: "//article[contains(@class, 'Discount')]",
          discount: {
            name_xpath: "//div[contains(@class, 'DiscountName')]",
            image_xpath: "/img[contains(@class, 'DiscountImage')]",
            new_price_xpath: "//div[contains(@class, 'DiscountNewPrice')]",
            old_price_xpath: "//div[contains(@class, 'DiscountOldPrice')]",
          }
        }
      ]
    }
  }

  subject { DiscountTypeParser.new(config).call }

  before do
    allow_any_instance_of(DiscountsPage).to receive(:to_html) do
      file = File.read('./spec/fixtures/shop.html')
      Capybara.string(file.to_s)
    end
  end

  it 'parses discounts' do
    expect(subject.count).to eq 5
  end
end
