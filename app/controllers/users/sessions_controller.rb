class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: {
      user: resource,
      token: resource.generate_jwt_token
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: { message: "Signed out successfully." }, status: :ok
    else
      render json: { error: "User not signed in." }, status: :unauthorized
    end
  end

  protected

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#new" }
  end

  def respond_with_error
    render json: { error: "Invalid Email or password." }, status: :unauthorized
  end
end

