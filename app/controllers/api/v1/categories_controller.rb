class Api::V1::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!, only: [:create, :update, :destroy]


  def authenticate_user!
    token = request.headers['Authorization'].split(' ').last
    user = User.decode_jwt_token(token)
    if user
      @current_user = user
    else
      render json: { error: 'Authentication required' }, status: :unauthorized
    end
  end




  def index
    categories = Category.all
    render json: categories, status: :ok
  end

  def show
    render json: @category, status: :ok
  end

  def create
    category = Category.new(category_params)
    if category.save
      render json: category, status: :created
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def update
    if @category.update(category_params)
      render json: @category, status: :ok
    else
      render json: { errors: @category.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    @category.destroy
    render json: { message: "Category deleted" }, status: :ok
  end

  private

  def authorize_admin!
    Rails.logger.info "Authorizing user: #{current_user.inspect}"
    unless current_user&.admin?
      render json: { error: "Access denied" }, status: :forbidden
    end
  end

  def find_category
    @category = Category.find_by(id: params[:id])
    render json: { errors: ["Category not found"] }, status: :not_found unless @category
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
