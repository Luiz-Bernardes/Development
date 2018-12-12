# gemfile
gem 'cocoon'

# app/assets/javascripts/application.js - SET AFTER JQUERY
//= require cocoon

# app/models/product.rb
accepts_nested_attributes_for :items, allow_destroy: true

# app/controllers/products_controller.rb
def new
  @product = Product.new
  @product.items.build
end

private
  def product_params
    params.require(:product).permit(:name, :description, items_attributes: [:id, :quantity, :value, :_destroy])
  end

# app/views/products/_form.html.slim
br
fieldset.js-event-products
  legend: span Produtos
  .js-product-remov
    = f.simple_fields_for :products do |product|
      = render 'shared/product_fields', f: product
    .js-products
    = link_to_add_association f, :products, \
      partial: 'shared/product_fields', class: 'btn btn-primary pull-right btn-add-product', \
      'data-association-insertion-node': '.js-products' do
        => fa_icon 'plus fw'
    br

# app/views/shared/_product_fields.slim
.nested-fields.js-parent-product
  .row.skn-inline-fields
    .col-md-2
      = f.input :value, input_html: { class: 'js-price-format' }
    .col-md-2
      = f.input :quantity, input_html: { class: 'quantity' }

    .col-md-3.skn-delete-button.elm-delete-button
      .pull-right
        = link_to_remove_association f, class: 'js-remove-product-button' do
          .btn.btn-danger.js-recalculate = fa_icon 'trash fw'

  hr.line

css:
  hr.line {
    margin: 25px 0;
  }


# javascript
$('.js-items').on('cocoon:after-insert', function(){
    startJsDatePicker();
    startJsPriceFormat();
})