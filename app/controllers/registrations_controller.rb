# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(_resource)
    edit_importance_path(id: Importance.names.keys.first.to_sym)
  end
end
