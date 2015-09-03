class RemoveAndAddColumnsForNormalization < ActiveRecord::Migration
  def change
    remove_columns :requests,
                   :url,
                   :requested_at,
                   :responded_in,
                   :referred_by,
                   :request_type,
                   :parameters,
                   :event_name
    add_column :requests, :machine_id, :integer
    add_column :requests, :site_id, :integer
  end
end
