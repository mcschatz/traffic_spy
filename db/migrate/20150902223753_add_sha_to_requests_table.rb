class AddShaToRequestsTable < ActiveRecord::Migration
  def change
    add_column :requests, :sha, :text
  end
end
