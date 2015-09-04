class CreateOperatingSystemsTable < ActiveRecord::Migration
  def change
    create_table :operating_systems do |t|
      t.text :name
    end
  end
end
