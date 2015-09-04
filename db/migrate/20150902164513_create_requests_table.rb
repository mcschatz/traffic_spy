class CreateRequestsTable < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer   :user_id
      t.integer   :url_id
      t.integer   :browser_id
      t.integer   :operating_system_id
      t.text      :sha
    end
  end
end
