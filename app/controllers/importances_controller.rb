# frozen_string_literal: true

class ImportancesController < ApplicationController
  before_action :clean_params, only: %i[update]
  before_action :set_importance, only: %i[edit update]

  def index
    @importances = policy_scope(Importance)
    @importances_values = @importances.all.map { |i| [i.name, i.value] }.to_h
  end

  def update_importances
    importance_params.each do |name, value|
      importance = Importance.find_by(name: name, user: current_user)
      importance.value = value
      importance.save
      @user_opportunities.each(&:save)
      authorize importance
    end
    redirect_to profile_path
  end

  def edit
    @current_values = current_criteria
    authorize @importance
  end

  def update
    authorize @importance
    values = importances_params[:values]

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

  def clean_params
    return if params[:importance].nil?

    values = params[:importance][:values]
    values = [values] unless values.is_a? Array # makes sure values is an array
    values = values.reject(&:empty?)
    params[:importance][:values] = values
  end

  def set_importance
    @importance = Importance.find_by(user: current_user, name: params[:id].to_sym)
  end

  def importance_params
    params.require(:importance).permit!()
  end

  def importances_params
    params.require(:importance).permit(values: [])
  end

  def redirect_next
    index = Importance.names.keys.find_index(params[:id].to_s)
    if !index.nil? && index + 1 < Importance.names.count
      next_importance = Importance.names.keys.at(index + 1).to_sym
      redirect_to edit_importance_path(id: next_importance)
    else
      params = []
      redirect_to importances_path
    end
  end

  def current_criteria
    @importance.criteria.map { |criterium| criterium.value }
  end
end
