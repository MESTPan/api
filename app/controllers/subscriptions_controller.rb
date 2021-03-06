class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :update, :destroy]
  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @subscriptions = Subscription.all

    render json: @subscriptions
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
    render json: @subscription
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @subscription = Subscription.new(subscription_params)

    if @subscription.save
      render json: @subscription, status: :created, location: @subscription
      BackendSlackbotService.new.send("New subscription by: #{@subscription.email}")
    else
      render json: {
        errors: [{
          message: @subscription.errors[:email],
          status: "422"
        }]
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /subscriptions/1
  # PATCH/PUT /subscriptions/1.json
  def update
    @subscription = Subscription.find(params[:id])

    if @subscription.update(subscription_params)
      head :no_content
    else
      render json: @subscription.errors, status: :unprocessable_entity
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription.destroy

    head :no_content
  end

  private

    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    def subscription_params
      params.require(:subscription).permit(:email)
      #params.require(:subscription).permit(:email)
    end
end
