class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def destroy
    if current_user
      current_user.update(jti: SecureRandom.uuid)
      sign_out(current_user)
      render json: { message: "Signed out successfully." }, status: :ok
    else
      render json: { error: "User not signed in." }, status: :unauthorized
    end
  end

  private

  def respond_with(resource, _opts = {})
    render json: {
      status: { code: 200, message: 'Logged in successfully.' },
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
    }
  end

  def respond_to_on_destroy
    head :no_content
  end
end