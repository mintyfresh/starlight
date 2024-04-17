# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update publish register check_in]

  # GET /events
  def index
    @events = authorized_scope(Event.all)
  end

  # GET /events/:slug
  def show
    authorize! @event
  end

  # GET /events/:slug/edit
  def edit
    authorize! @event
  end

  # PATCH /events/:slug
  def update
    authorize! @event

    if @event.update(event_update_params)
      redirect_to event_path(@event), notice: t('.success', name: @event.name)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # POST /events/:slug/publish
  def publish
    authorize! @event

    if @event.publish
      flash.notice = t('.success', name: @event.name)
    else
      flash.alert = t('.failure', errors: @event.errors.full_messages.to_sentence)
    end

    redirect_back fallback_location: event_path(@event)
  end

  # POST /events/:slug/register
  def register
    authorize! @event

    if @event.register(current_user)
      flash.notice = t('.success', name: @event.name)
    else
      flash.alert = t('.failure', errors: @event.errors.full_messages.to_sentence)
    end

    redirect_back fallback_location: event_path(@event)
  end

  # POST /events/:slug/check_in
  def check_in
    authorize! @event

    if @event.check_in(current_user)
      flash.notice = t('.success', name: @event.name)
    else
      flash.alert = t('.failure', errors: @event.errors.full_messages.to_sentence)
    end

    redirect_back fallback_location: event_path(@event)
  end

private

  def set_event
    @event = Event.find_by!(slug: params[:slug])
  end

  # @return [ActionController::Parameters]
  def event_update_params
    authorized(params.require(:event), as: :update, with: "#{@event.class.name}Policy".constantize)
  end
end
