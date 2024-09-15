class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  JWT_ALGO = 'HS256'.freeze

  enum role: { user: 'user', admin: 'admin' }

  after_initialize :set_default_role, if: :new_record?

  def jwt_payload
    super.merge('jti' => jti)
  end

  def set_default_role
    self.role ||= :user
  end

  # Generate JWT token
  def generate_jwt_token
    exp = 30.days.from_now

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

  # Custom method to decode a JWT token and return the user
  def self.decode_jwt_token(token)
    begin
      decoded = JWT.decode(token, ENV['DEVISE_TOKEN'], true, { algorithm: JWT_ALGO }).first
      user_id = decoded['user_id']
      find_by(id: user_id)
    rescue JWT::DecodeError => e
      Rails.logger.error("JWT Decode Error: #{e.message}")
      nil
    end
  end
end
