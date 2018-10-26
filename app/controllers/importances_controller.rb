class ImportancesController < ApplicationController
  before_action :set_importance, only: [:show, :edit, :update]

  def index
    @importances = Importance.all
  end

  def show
  end

  def edit
    @importance.value = params[:value]
  end

  def update
    if @importance.value.update(params[:value])
      redirect_to importances_path
    else
      render :edit
    end
  end

  private

    def set_importance
      @importance = Importance.find(params[:id])
    end

    def importance_params
      params.require(:importance).permit(:type, :value)
    end
end
