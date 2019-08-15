class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /orders
  # def menu
  #   #send the kitchen a get request for menu
  #   # @menu = HTTParty.get('/available')
  #   # @menu = {
  #   #         food_id: params[:id],
  #   #         food_name: params[:name]
  #   #         }

  #   @menu = {
  #     length: 2,
  #     items: [
  #       {
  #         id: 1,
  #         name: 'Pizza'
  #       }
  #     ]
  #   }
    

  #   render json: @menu
  # end

  # # GET /orders/1
  # def show

  #   render json: @order
  # end

  def new
    deliver(Order.last,User.last)
 
    # render json: @order
  end

  # def orders
  #   # if params[:created]
  #   # @send_kitchen = {
  #   #   id: params[:order_id] => {@orders
  #   #   }
  #   # }
  #   render json: @send_kitchen
  # end

  # POST /orders
  def create
    # byebug
    @user = User.create(first_name: params[:first_name],
      last_name: params[:last_name],
      phone_number: params[:phone_number].to_i)
      # byebug

@address = Address.create(city: params[:city],
            state: params[:state],
            street: params[:street],
            user_id: @user.id)

            @foods = []
params[:foods].each do |food|
  @food = Food.create(kitchen_food_id: food[:kitchen_food_id],
    quantity: food[:quantity])
    @foods << @food
  end
@order = Order.create(user_id:@user.id)
    if @order.save
      @result = HTTParty.post("http://192.168.0.174:3000/deliveries", 
        :body => {
          order_id: @order.id,
          foods: @foods
        }.to_json,
        :headers => { 'Content-Type' => 'application/json' } )
        # byebug
        
      render json: @result, status: :created, location: @order

    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def orders_status
    send = HTTParty.get("http://192.168.0.180:3000/orders/status")

      @order = Order.find_by(id: params[:order_id])
      @user = User.find_by(id: @order.user_id)
      if params[:status] == "completed"
        deliver(Order.last,User.last)
      end
  end

  def deliver(order,user)
      @result = HTTParty.post("http://192.168.0.174:3000/deliveries", 
        :body => {
          order_id: order.id,
          city: user.city,
          state: user.state,
          address: user.street,
          phone: user.phone_number,
          name: user.first_name
          }.to_json,
        :headers => { 'Content-Type' => 'application/json' } )

    render json: @deliver, status: :created, location: @order
  end

  def deliver_status
    send = HTTParty.get("http://192.168.0.174:3000/deliveries/status")

    @order = Order.find_by(id: params[:order_id])
    @user = User.find_by(id: @order.user_id)
    if params[:notice]
      if params[:notice] == "delivered"
        sms(@user,params[:notice])
      end
    else
        sms(@user,params[:error])
    end
  end

  def sms(user,notice)
    @sms = {"from": "+60 192022325",
            "to": user.phone_number, 
            "message": notice
          }
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:user_id, :food_id)
    end

    def address_params
      params.require(:order).permit(:user_id, :food_id)
    end
end
