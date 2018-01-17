RSpec.describe DiscountTypeParser do
  describe '#call' do
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

    subject { described_class.new(config).call }

    before do
      allow_any_instance_of(DiscountsPage).to receive(:to_html) do
        discounts_page = File.read('./spec/fixtures/shop.html')
        Capybara.string(discounts_page)
      end
    end

    it 'parses discounts' do
      expect(subject.first).to eq({
        image: "http://www.atbmarket.com/attachments/product/d/0/7/5/5/d07558e0a9d07eea6bb86930cab1d4b8.jpg",
        name: "Ветчина Куриная, варёная ТМ «Своя Лінія» - 500 г",
        new_price: 39.95,
        old_price: 46.95,
      })
      expect(subject.count).to eq 5
    end
  end
end
