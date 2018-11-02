class ImportancePolicy < ApplicationPolicy
  def edit?
    @record.user == @user
  end

  def update?
    @record.user == @user
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
