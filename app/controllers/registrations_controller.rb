# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action :set_event
  before_action :set_registration

  # GET /events/:event_slug/registration
  def show
    # Nothing to do here
  end

  # POST /events/:event_slug/registration
  def create
    @registration.assign_attributes(registration_params)

    if @registration.save(context: :register)
      redirect_to event_path(@event), notice: t('.success', name: @event.name)
    else
      render :show, status: :unprocessable_entity
    end
  end

  # DELETE /events/:event_slug/registration
  def destroy
    # TODO: Implement a way to cancel registration
    registration.destroy!

    redirect_to event_path(@event), notice: t('.success', name: @event.name)
  end

private

  def set_event
    @event = Event.find_by!(slug: params[:event_slug])
    authorize! @event, to: :register?
  end

  def set_registration
    @registration = @event.registrations.find_or_initialize_by(player: current_user)
  end

  # @return [ActionController::Parameters]
  def registration_params
    authorized(params.fetch(:registration, {}), as: :create)
  end
end
