class CreateRequestsTable < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer   :user_id
      t.integer   :url_id
      t.integer   :browser_id
      t.integer   :operating_system_id
      t.integer   :resolution_id
      t.integer   :type_id
      t.integer   :referral_id
      t.integer   :event_id
      t.integer   :response_time
      t.text      :sha
    end
  end
end
