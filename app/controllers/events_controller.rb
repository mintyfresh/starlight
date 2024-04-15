# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update publish]

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

    @event.role_config or @event.build_role_config
  end

  # PATCH /events/:slug
  def update
    authorize! @event

    if @event.update(event_update_params)
      redirect_to @event, notice: t('.success', name: @event.name)
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

    redirect_back fallback_location: @event
  end

private

  def set_event
    @event = Event.find_by!(slug: params[:slug])
  end

  # @return [ActionController::Parameters]
  def event_update_params
    authorized(params.require(:event), as: :update)
  end
end
