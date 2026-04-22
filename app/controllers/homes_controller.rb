class HomesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  skip_after_action :verify_pundit_authorization, only: [:index]
  def index
  end
end
