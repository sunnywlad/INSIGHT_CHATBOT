class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: "Product created successfully.", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @product = Product.find(params[:id])
    @chats = @product.chats.where(user: current_user)
  end

  private

  def product_params
    params.require(:product).permit(:name, :brand)
  end
end
