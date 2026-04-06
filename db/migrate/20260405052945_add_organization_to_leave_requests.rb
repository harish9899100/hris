class AddOrganizationToLeaveRequests < ActiveRecord::Migration[8.1]
  def change
    add_reference :leave_requests, :organization, null: false, foreign_key: true
  end
end
