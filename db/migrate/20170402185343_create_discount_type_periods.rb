class CreateDiscountTypePeriods < ActiveRecord::Migration[5.0]
  def change
    create_table :discount_type_periods do |t|
      t.datetime :start_date,                         null: false
      t.datetime :end_date,                           null: false
      t.belongs_to :discount_type, foreign_key: true, null: false
    end
  end
end
