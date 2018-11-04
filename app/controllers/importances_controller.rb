# frozen_string_literal: true

class ImportancesController < ApplicationController
  before_action :clean_params
  before_action :set_importance, only: %i[edit update]

  def index
    @importances = policy_scope(Importance)
    @importances_values = @importances.all.map { |i| [i.name, i.value] }.to_h.to_json
  end

  def edit
    @current_values = current_criteria
    authorize @importance
  end

  def update
    @importance.criteria_attributes = importance_params[:criteria_attributes]

    if @importance.save
      redirect_next
    else
      render :edit
    end
    authorize @importance
  end

  private

  def clean_params
    return if params[:importance].nil?

    criteria_attributes = params[:importance][:criteria_attributes]
    return unless criteria_attributes.include?("0")

    values = criteria_attributes.delete("0")[:value]
    values = [values] unless values.is_a? Array # makes sure values is an array
    values = values.reject(&:empty?).map(&:to_i) # clean array
    criteria_attributes[:value] = values
  end

  def set_importance
    @importance = Importance.find_by(user: current_user, name: params[:id].to_sym)
  end

  def importance_params
    params.require(:importance).permit(criteria_attributes: {})
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
