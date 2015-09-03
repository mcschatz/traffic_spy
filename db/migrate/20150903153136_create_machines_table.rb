class CreateMachinesTable < ActiveRecord::Migration
  def change
    create_table :machines do |t|
      t.text      :browser
      t.text      :os
      t.text      :resolution_width
      t.text      :resolution_height
      t.text      :ip
    end
  end
end
