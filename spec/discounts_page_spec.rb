RSpec.describe DiscountsPage do
  describe '#url' do
    let(:page) do
      described_class.new(
        discounts_url: url,
        discount_parser: discount_parser,
        discounts_xpath: "some-xpath"
      )
    end
    let(:url) { 'https://myshop.ua/discounts/good' }
    let(:discount_parser) { DiscountParser.new({}) }

    subject { page.url }

    context 'without pagination' do
      it { is_expected.to eq url }
    end

    context 'with pagination' do
      let(:page) do
        described_class.new(
          discounts_url: url,
          discount_parser: discount_parser,
          discounts_xpath: "some-xpath",
          pagination: {
            pages_count_xpath: "//a[contains(@class, 'pagination')]"
          }
        )
      end

      it { is_expected.to eq "#{url}?page=1" }

      describe 'on the next page' do
        subject { page.next.url }

        it { is_expected.to eq "#{url}?page=2" }
      end
    end
  end
end
