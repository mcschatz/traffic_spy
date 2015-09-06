class AddRequestedAtColumnToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :requested_at, :datetime
  end
end
