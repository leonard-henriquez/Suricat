# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[update destroy]

  def index
    @events = policy_scope(Event)
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    authorize @event

    render json: @event if @event.save
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
    params.require(:event).permit(:name, :start_time)
  end
end
