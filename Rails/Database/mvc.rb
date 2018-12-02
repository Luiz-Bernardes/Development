#model //product.rb
class Product < ActiveRecord::Base
  validates :name, :price ,  presence: true
  belongs_to :category
  has_many :items
  attr_accessor :formatted_price
end

#controller //products_controller.rb
class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      flash[:success] = 'Produto criado com sucesso.'
      redirect_to products_path
    else
      flash[:error] = 'Favor verificar os erros do formulário'
      render :new
    end
  end

  def update
    if @product.update(product_params)
      flash[:success] = 'Product atualizado com sucesso.'
      redirect_to products_path
    else
      flash[:error] = 'Favor verificar os erros do formulário'
      render :edit
    end
  end

  def destroy
    @product.destroy
    flash[:success] = 'Produto deletado com sucesso.'
    redirect_to products_path
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :category_id, :quantity, etc: )
    end

end

#view
#_form.html.slim
.row
  .col-md-6
    = simple_form_for(@product) do |f|
      .form-inputs
        = f.input :name
        = f.association :category
        = f.input :description

      .btn-group.pull-right
        = link_to t('.cancel', default: t('helpers.links.cancel')), products_path, class: 'btn btn-default'
        = f.button :submit, class: 'btn-primary'

#edit.html.slim , #new.html.slim
= render partial: "form"

#index.html.slim
table.table.js-datatable
  thead
    tr
      th = model_class.human_attribute_name(:enabled)
      th = model_class.human_attribute_name(:name)
      th = model_class.human_attribute_name(:category)
      th = model_class.human_attribute_name(:quantity)
      th = t '.actions', default: t("helpers.actions")
  tbody
    - @products.each do |product|
      tr
        td = pretty_boolean product.enabled
        td = product.name
        td = product.category.try(:name)
        td = product.quantity

        td
          .btn-group
            = link_to edit_product_path(product), class: 'btn btn-primary btn-xs', \
              data: { toggle: 'tooltip', title: 'Editar' }  do
              => fa_icon 'pencil fw'

            = link_to product_path(product), method: :delete, class: 'btn btn-danger btn-xs', \
              data: { toggle: 'tooltip', title: 'Excluir', 'confirm-message' => 'Deseja excluir este produto?', \
              'confirm-title' => 'Excluir produto' } do
                => fa_icon 'trash fw'

#routes
resources :products
