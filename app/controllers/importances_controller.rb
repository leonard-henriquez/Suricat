# frozen_string_literal: true

class ImportancesController < ApplicationController
  before_action :set_importance, only: %i[edit update]

  def index
    @importances = policy_scope(Importance)
  end

  def edit
    authorize @importance
  end

  def update
    @importance.criteria.destroy_all
    @criterium = Criterium.new(importance_params[:criteria])
    @criterium.importance = @importance
    @criterium.save

    # raise
    if @importance.save
      redirect_next
    else
      render :edit
    end
    authorize @importance
  end

  private

  def set_importance
    @importance = Importance.find_by(user: current_user, name: params[:id].to_sym)
  end

  def importance_params
    params.require(:importance).permit(criteria: %i[rank value])
  end

  def redirect_next
    index = Importance.names.keys.find_index(params[:id].to_s)
    if !index.nil? && index + 1 < Importance.names.count
      next_importance = Importance.name_for_display.at(index + 1).to_sym
      redirect_to edit_importance_path(id: next_importance)
    else
      params = []
      redirect_to importances_path
    end
  end
end
