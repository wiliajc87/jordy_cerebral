class PaymentsController < ApplicationController
  before_action :set_user, only: %i[create destroy]

  def create
    begin
      @user.save if @user.pay && sessioned_user?
    rescue AASM::InvalidTransition
      flash.alert = 'Payment not created'
    end
    redirect_to @user
  end

  def destroy
    begin
      @user.save if @user.cancel && sessioned_user?
    rescue AASM::InvalidTransition
      flash.alert = 'Payment not canceled'
    end
    redirect_to @user
  end
end
