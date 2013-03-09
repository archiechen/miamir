class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from(ActiveResource::BadRequest){
    render json:{},:status => 400
  }
  rescue_from(ActiveResource::UnauthorizedAccess){
    render json:{},:status => 401
  }
end
