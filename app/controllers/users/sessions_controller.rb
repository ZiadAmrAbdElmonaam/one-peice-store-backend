class Users::SessionsController < Devise::SessionsController
  private

  def respond_with(resource, _opts = {})
    render json: resource
  end
end
