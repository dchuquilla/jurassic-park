# frozen_string_literal: true

# User model with devise and devise-jwt
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable

  def jwt_payload
    {
      'sub' => id
    }
  end
end
