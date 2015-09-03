class CreateSitesTable < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.text      :url
      t.datetime  :requested_at
      t.integer   :responded_in
      t.text      :referred_by
      t.text      :request_type
      t.text      :parameters
      t.text      :event_name
    end
  end
end
