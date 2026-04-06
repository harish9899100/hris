class AddApprovedByToLeaveRequests < ActiveRecord::Migration[8.1]
  def change
    add_reference :leave_requests, :approved_by, foreign_key: { to_table: :users }
  end
end
