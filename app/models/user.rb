class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  JWT_ALGO = 'HS256'.freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: self

  # Generate JWT token
  def generate_jwt_token
    exp = token_expired? ? 30.days.from_now : token_expires_at

    payload = {
      user_id: id,
      exp: exp.to_i,
      jti: jti # Include jti in the payload
    }
    begin
      token = JWT.encode(payload, ENV['DEVISE_TOKEN'], JWT_ALGO)
      update(token_expires_at: exp)
      token
    rescue JWT::EncodeError => e
      Rails.logger.error("JWT Encode Error: #{e.message}")
      nil
    end
  end

  # Check if token is expired
  def token_expired?
    return true unless token_expires_at.present?

    Time.now >= token_expires_at
  end
end
