class Api::V1::ProductsController < ApplicationController
  def index
    products = Product.all
    render json: products, status: :ok
  end

  def show
    product = Product.find(params[:id])
    if product
      render json: product, status: :ok
    else
      render json: {
        errors: ["Product not found"]
      }, status: :not_found
    end
  end

  def create
    product = Product.new(product_params)
    product.category = Category.find(params[:category_id])
    if product.save
      render json: product, status: :created
    else
      render json: {
        errors: product.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    product = Product.find(params[:id])
    if product.update(product_params)
      render json: product, status: :ok
    else
      render json: {
        errors: product.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy
    render json: "Product deleted", status: :ok
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price)
  end
end
