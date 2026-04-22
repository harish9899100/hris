class DashboardPolicy < ApplicationPolicy
  def index? = true

  class Scope < Scope
    def resolve = scope
  end
end