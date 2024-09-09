class Api::V1::CategoriesController < ApplicationController
  def index
    categories = Category.all
    render json: categories, status: :ok
  end

  def show
    category = Category.find(params[:id])
    if category
      render json: category, status: :ok
    else
      render json: {
        errors: ["Category not found"]
      }, status: :not_found
    end
  end

  def create
    category = Category.new(
      name: category_params[:name],
      description: category_params[:description]
    )
    if category.save
      render json: category, status: :created
    else
      render json: {
        errors: category.errors.full_messages
      }
    end
  end

  def update
    category = Category.find(params[:id])
    if category.update(category_params)
      render json: category, status: :ok
    else
      render json: {
        errors: category.errors.full_messages
      }, status: bad_request
    end
  end

  def destroy
    category = Category.find(params[:id])
    category.destroy
    render json: "Category deleted", status: :ok
  end


  private
  def category_params
    params.require(:category).permit(:name, :description)
  end
end
