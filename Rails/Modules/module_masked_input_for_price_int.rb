# lib/masked_input.rb
# frozen_string_literal: true
# Create formatted field - TODO: remove use for simple form and use only content tags
class MaskedInput
  def initialize(form, field, args = {})
    @form   = form
    @field  = field
    @args   = args
  end

  def to_html
    formatted
  end

  private

  # Base inputs
  def formatted
    @form.input accessor, required: required, wrapper_html: { class: wrapper_klass } do
      @form.input_field(accessor, value: value, class: klass, data: data).concat(hint).concat(error).concat(hidden)
    end
  end

  def hidden
    @form.input @field, as: :hidden, input_html: { class: hidden_klass }
  end

  def error
    @form.error @field
  end

  def hint
    return '' unless hint?
    @form.hint @args[:hint]
  end

  # Values
  def accessor
    "formatted_#{@field}".to_sym
  end

  def value
    @form.object.send(@field)
  end

  # Definitions
  def required
    @args[:required].presence || false
  end

  # html classes
  def error?
    @form.object.errors.messages[@field].present?
  end

  def hint?
    @args[:hint].present?
  end

  def klass
    "form-control #{@args[:class]}"
  end

  def hidden_klass
    "js-hidden-value-#{@field}"
  end

  def error_klass
    error? ? 'has-error' : ''
  end

  def wrapper_klass
    "#{error_klass} #{@args[:wrapper_class]}"
  end

  def data
    { target: ".js-hidden-value-#{@field}" }
  end
end

# views/form
= MaskedInput.new(f, :price_value, class: 'js-transform-value js-price-format',
        wrapper_class: 'js-parent-transform').to_html




#app/assets/javascripts/shared/transform.js
/* Handle transform value */

$(function () {
  $(document).on('input', '.js-transform-value', transformValue);
});

function transformValue () {
  var $this = $(this);
  var newValue = String($this.unmask()).replace(/\s/g, '');
  $this.closest('.js-parent-transform').find($this.data('target')).val(newValue)
}

#app/assets/javascripts/shared/masks.js
$(function () {
  startJsPriceFields();
})

function startJsPriceFields () {
  $('.js-price-format').priceFormat({
    prefix: 'R$ ',
    centsSeparator: ',',
    thousandsSeparator: '.',
    allowNegative: true
  });

  $('.js-percent-format').priceFormat({
    prefix: '',
    centsSeparator: ',',
    thousandsSeparator: '',
    allowNegative: true
  });
}