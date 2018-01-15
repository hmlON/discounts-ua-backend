RSpec.describe 'Application', type: :feature do
  xit 'should display all discounts on the homepage' do
    shop = Fabricate(:shop)

    VCR.use_cassette('all_shops', record: :new_episodes) do
      visit '/'
    end

    expect(page).to have_content shop.name.titleize
    shop.discount_types.each do |discount_type|
      expect(page).to have_content discount_type.name.humanize
      expect(page).to have_content discount_type.active_period.end_date.strftime('%d %b %Y')

      discount_type.active_period.discounts.each do |discount|
        expect(page).to have_content discount.name
      end
    end
  end
end
