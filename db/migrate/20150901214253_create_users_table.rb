class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :identifier
      t.text :root_url
    end
  end
end
