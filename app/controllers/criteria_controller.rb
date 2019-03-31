# frozen_string_literal: true

class CriteriaController < ApplicationController
  layout 'no_sidebar'

  before_action :set_importance, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_criterium, only: [:edit, :update, :destroy]

  def new
    @criterium = Criterium.new
  end

  def create
    authorize @criterium
    @criterium = Criterium.new(criterium_params)
    @criterium.importance = @importance
    if @criterium.save
      redirect_to importance_path(@importance)
    else
      render :new
    end
  end

  def edit; end

  def update
    authorize @criterium
    if @criterium.update(criterium_params)
      redirect_to importance_path(@importance)
    else
      render :edit
    end
  end

  def destroy
    authorize @criterium
    @criterium.destroy
    redirect_to importance_path(@importance)
  end

  private

  def set_importance
    @importance = Importance.find(params[:importance_id])
  end

  def set_criterium
    @criterium = Criterium.find(params[:id])
  end

  def criterium_params
    params.require(:criterium).permit(:importance_id, :value, :rank)
  end
end
