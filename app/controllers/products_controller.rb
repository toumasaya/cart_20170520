class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to product_path(@product), success: "Product create!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    @product.update(product_params)

    if @product
      redirect_to product_path(@product), success: "Product update!"
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, success: "Product delete!"
  end

  private

  def find_product
    @product = Product.find_by(id: params[:id])
    redirect_to products_path, warning: "Product not found" if @product.nil?
  end

  def product_params
    params.require(:product).permit(:name, :price, :description, :image)
  end
end
