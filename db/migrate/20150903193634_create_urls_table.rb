class CreateUrlsTable < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.text :address
    end
  end
end
