class CardsController < ApplicationController
  def show
    @card = Card.where(user_id: params[:user_id])
    respond_to do |format|
      format.html { redirect_to @card }
      format.js {}
      format.json { render json: @card, location: @card }
    end
  end
end


# def create
#   @user = User.new(params[:user])
#
#   respond_to do |format|
#     if @user.save
#       format.html { redirect_to @user, notice: 'User was successfully created.' }
#       format.js   {}
#       format.json { render json: @user, status: :created, location: @user }
#     else
#       format.html { render action: "new" }
#       format.json { render json: @user.errors, status: :unprocessable_entity }
#     end
#   end
# end
