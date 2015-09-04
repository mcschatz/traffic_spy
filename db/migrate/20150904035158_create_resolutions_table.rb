class CreateResolutionsTable < ActiveRecord::Migration
  def change
    create_table :resolutions do |t|
      t.text :description
    end
  end
end
