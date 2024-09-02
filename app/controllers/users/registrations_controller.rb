class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    resource.save
    render_resource(resource)
  end

  private

  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      render json: {
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
end
