[![Build Status](https://semaphoreci.com/api/v1/hmlon/discounts-ua/branches/master/shields_badge.svg)](https://semaphoreci.com/hmlon/discounts-ua)
# Discounts-UA
An application with discounts form ukrainian shops.

#### Technologies:
- Framework: Sinatra
- Database: PostgreSQL

## Adding new shops
Configuration for parsing shops is located in `/config/shops.yml`.  
Commented parameters are optional.
``` yml
shop_slug: # shop slug that is displayed in URL
  name: # shop name
  url: # shop url
  discount_types:
    discount_type_slug: # discount type slug that is displayed in URL
      name: # discount type name
      url: # discount type URL
      # js: # enable if page needs to be loaded in a browser (e.g. site on React)
      # scroll_to_load: # enable for pages that load discounts on scroll
      pagination:
        pages_count_xpath: # xpath to the count of pages
        # parameter: # pagination url parameter (default is 'page')
        # starts_at: # number of the first page of pagination (default is 1)
        # step: # step for the next pages (default is 1)
      period:
        starts_at: # any date in the past that discount type started on
        duration_in_days: # duration of discount type
      discounts_xpath: # xpath to all discounts on the page
      discount:
        name_xpath: # xpath to discount name
        image_xpath: # xpath to discount image
        new_price_xpath: # xpath to discount new price
        # new_price_divided: # enable if new price's integer and fraction parts are divided
        # new_price_integer_xpath: # xpath to integer part of discount new price
        # new_price_fraction_xpath: # xpath to graction part of discount new price
        old_price_xpath: # xpath to discount old price
        # old_price_divided: # enable if old price's integer and fraction parts are divided
        # old_price_integer_xpath: # xpath to integer part of discount old price
        # old_price_fraction_xpath: # xpath to fraction part of discount old price
        width_on_mobile: # recommended width for discount on mobile, specified as a fraction of 1 (e.g. 0.5)
```
