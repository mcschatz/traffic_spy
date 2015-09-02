class CreateRequestsTable < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer   :user_id
      t.text      :url
      t.datetime  :requested_at
      t.integer   :responded_in
      t.text      :referred_by
      t.text      :request_type
      t.text      :parameters
      t.text      :event_name
      t.text      :browser
      t.text      :os
      t.text      :resolution_width
      t.text      :resolution_height
      t.text      :ip
    end
  end
end
