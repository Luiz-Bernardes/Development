# gemfile
gem 'maskedinput-rails'

# app/assets/javascripts/application.js
$(function() {
    startJsMasks();
});

function startJsMasks(){
  $('.js-mask-date').mask('99/99/9999');
  $('.js-mask-cnpj').mask('99.999.999/9999-99');
  $('.js-mask-cep').mask('99999-999');
  $('.js-mask-cpf').mask('999.999.999-99');
  $('.js-mask-phone').mask('(22)99999-999?9');
}