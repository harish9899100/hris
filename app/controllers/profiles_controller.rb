class ProfilesController < ApplicationController
  def show
    @employee = current_user.employee
  end
end
