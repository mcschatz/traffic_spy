class RemoveMachineColumnsFromRequests < ActiveRecord::Migration
  def change
    remove_columns :requests,
                   :os,
                   :browser,
                   :resolution_width,
                   :resolution_height,
                   :ip
  end
end
