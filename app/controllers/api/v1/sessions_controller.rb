# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def create
        user = User.find_by(email: params[:email])

        if user&.valid_password?(params[:password])
          jwt = JWT.encode(user.jwt_payload, Rails.application.secrets.secret_key_base)
          render json: { jwt: jwt }
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end
    end
  end
end
