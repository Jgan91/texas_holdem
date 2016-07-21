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
