class CreateTypesTable < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.text :name
    end
  end
end
