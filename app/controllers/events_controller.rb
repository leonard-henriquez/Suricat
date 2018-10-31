class EventsController < ApplicationController
  before_action :set_event, only: [:update, :destroy]

  def index
    @events = policy_scope(Event)
  end

  def create
    authorize @event
    @event = Event.new(event_params)
    if @event.save
      redirect_to events_path
    else
      render :new
    end
  end

  def update
    authorize @event
    if @event.update(event_params)
      redirect_to event_path(@event)
    else
      render :edit
    end
  end

  def destroy
    authorize @event
    @event.destroy
    redirect_to events_path
  end

  def sidebar?
    true
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :date)
  end
end
