# frozen_string_literal: true

class ImportancesController < ApplicationController
  before_action :set_importance, only: [:edit, :update]

  def index
    @importances_values = current_user.importances_value
  end

  def update_importances
    importance_values_params.each do |name, value|
      importance = Importance.find_by(name: name, user: current_user)
      importance.value = value
      importance.save
      @user_opportunities.each(&:save)
      authorize importance
    end

    # proposes to download the extension if the user is new (intro==true)
    if current_user.intro
      redirect_to profile_path
    else
      redirect_to extension_path
    end
  end

  def edit
    @current_values = current_criteria_values
  end

  def update
    values = criterium_values_params

    # delete previous values
    @importance.criteria.destroy_all

    # rewrite them all
    values.each_with_index do |value, index|
      criterium = Criterium.new(value: value, rank: index)
      criterium.importance = @importance
      criterium.save
    end

    if @importance.save
      @user_opportunities.each(&:save)
      redirect_next
    else
      render :edit
    end
  end

  private

  def set_importance
    @importance = Importance.find_by(user: current_user, name: params[:id].to_sym)
    authorize @importance
  end

  def importance_values_params
    params.require(:importance).permit!
  end

  def criterium_values_params
    params.require(:importance).permit(values: [])['values'].reject { |x| x.nil? || x == '' }
  end

  def redirect_next
    index = Importance.names.keys.find_index(params[:id].to_s)
    if !index.nil? && index + 1 < Importance.names.count
      next_importance = Importance.names.keys.at(index + 1).to_sym
      redirect_to edit_importance_path(id: next_importance)
    else
      # reset params
      params = []
      redirect_to importances_path
    end
  end

  def current_criteria_values
    @importance.criteria.map(&:value)
  end
end
