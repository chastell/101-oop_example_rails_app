# app/controllers/reservations_controller.rb
class ReservationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  rescue_from ArgumentError, with: :argument_error

  def create
    if lock_service.call
      render json: {}, status: :created
    else
      render json: {}, status: :conflict
    end
  end

  private

  def argument_error
    render json: { error: 'Bad arguments' }, status: :bad_request
  end

  def lock_service_class
    @lock_service_class ||= ServiceProvider.get(:lock_service)
  end

  def lock_service
    @lock_service ||= lock_service_class.new(user_id: user_id, item_id: item_id)
  end

  def user_id
    @user_id ||= params[:user_id]
  end

  def item_id
    @item_id ||= params[:item_id]
  end
end
