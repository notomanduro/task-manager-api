# require 'tiddle'
require 'jwt'

class Api::Auth::SessionsController < ApplicationController
    def create
        @user = User.where(email: params[:email]).first 
        
        if @user&.valid_password?(params[:password])
            session[:user_id] = @user.id
            token = JWT.encode({ user_id: @user.id }, Rails.application.secrets.jwt_secret, 'HS256')
            render json: { user: @user, token: token }, status: :ok
        else  
            render json: { error: 'invalid credential' }, status: :unauthorizes
        end 
    end 

    def destroy  
    end 
end
