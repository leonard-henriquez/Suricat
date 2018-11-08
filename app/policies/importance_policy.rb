# frozen_string_literal: true

class ImportancePolicy < ApplicationPolicy
  def edit?
    true
  end

  def update_importances?
    true
  end

  def update?
    true
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
