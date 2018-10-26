class CriteriaController < ApplicationController
  before_action :set_importance, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_criterium, only: [:edit, :update, :destroy]

  def new
    @criterium = Criterium.new
  end

  def create
    @criterium = Criterium.new(criterium_params)
    @criterium.importance = @importance
    if @criterium.save
      redirect_to importance_path(@importance)
    else
      render :new
    end
  end
  end

  def edit
  end

  def update
    if @criterium.update(criterium_params)
      redirect_to importance_path(@importance)
    else
      render :edit
    end
  end
  end

  def destroy
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
