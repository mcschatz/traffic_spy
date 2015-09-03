class CreateRequestsTable < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer   :user_id
      t.integer   :url_id
      t.text      :sha
    end
  end
end
