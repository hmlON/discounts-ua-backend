class CreateDiscounts < ActiveRecord::Migration[5.0]
  def change
    create_table :discounts do |t|
      t.string :name,          null: false
      t.string :img_url,       null: false
      t.integer :price_new,    null: false
      t.integer :price_old,    null: false
      t.datetime :start_date
      t.datetime :end_date
      t.string :shop_name,     null: false
      t.string :discount_type, null: false
      t.timestamps
    end
  end
end
