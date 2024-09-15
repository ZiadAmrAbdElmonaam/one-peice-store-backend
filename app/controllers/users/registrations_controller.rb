class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)
    resource.role = params[:user][:role] if params[:user][:role].present? && current_user&.admin?

    if resource.save
      render json: { message: "You have signed up successfully" }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end

  end

  private

  def respond_with(resource, _opts = {})
    render json: { message: "You have signed up successfully" }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end

  protected

  def set_flash_message!(key, kind, options = {})
    # Do nothing to prevent flash from being set
  end

  def set_flash_message(key, kind, options = {})
    # Override to prevent flash from being set
  end

  # Prevent flash messages in other Devise hooks
  def require_no_authentication
    if warden.authenticated?(resource_name)
      render json: { error: "You are already signed in." }, status: :unauthorized
    end
  end
end
