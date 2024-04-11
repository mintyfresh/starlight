# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update publish]

  # GET /events/:slug
  def show
    # nothing to do here
  end

  # GET /events/:slug/edit
  def edit
    # nothing to do here
  end

  # PATCH /events/:slug
  def update
    if @event.update(event_update_params)
      redirect_to @event, notice: t('.success', name: @event.name)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # POST /events/:slug/publish
  def publish
    if @event.publish
      flash.notice = t('.success', name: @event.name)
    else
      flash.alert = t('.failure', errors: @event.errors.full_messages.to_sentence)
    end

    redirect_back fallback_location: @event
  end

private

  def set_event
    @event = Event.find_by!(slug: params[:slug])
  end

  def event_update_params
    params.require(:event).permit(
      :name, :location, :description, :time_zone, :starts_at, :ends_at,
      :registration_starts_at, :registration_ends_at, :registrations_limit
    )
  end
end
