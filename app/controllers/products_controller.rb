class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user = current_user
    @product.name = @product.name.titleize.strip
    @product.brand = @product.brand.upcase.strip
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

  def destroy
    @product = Product.find(params[:id])
    referer = request.referer
    @product.destroy

    if referer&.include?(product_path(@product))
      redirect_to products_path, notice: "Product deleted."
    else
      redirect_back_or_to products_path, notice: "Product deleted."
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :brand)
  end
end
