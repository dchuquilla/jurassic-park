# frozen_string_literal: true

module Api
  module V1
    # Devise user controller
    class UsersController < ApplicationController
      def create
        @user = User.new(user_params)
        if @user.save
          jwt = generate_jwt(@user)
          render json: { user: @user, jwt: jwt }, status: :created
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

      def generate_jwt(user)
        JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
      end
    end
  end
end
