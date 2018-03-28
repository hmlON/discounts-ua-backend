class AddUniqToShopsSlug < ActiveRecord::Migration[5.1]
  def change
    add_index :shops, :slug, unique: true
  end
end
