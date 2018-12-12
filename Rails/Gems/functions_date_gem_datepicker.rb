# view
= f.input :scheduled_at, input_html: { class: 'js-datepicker',
value: f.object.scheduled_at.try(:strftime, '%d/%m/%Y') != nil ?
f.object.scheduled_at.try(:strftime, '%d/%m/%Y') : DateTime.now.try(:strftime, '%d/%m/%Y') }, as: :string

#gemfile
gem 'bootstrap-datepicker-rails'

#app/assets/javascripts/application.js
$(function() {
    startJsDatePicker();
});

function startJsDatePicker(){
  $('.js-datepicker').datepicker({
    dateFormat: 'dd/mm/yy',
    dayNames: ['Domingo','Segunda','Terça','Quarta','Quinta','Sexta','Sábado'],
    dayNamesMin: ['D','S','T','Q','Q','S','S','D'],
    dayNamesShort: ['Dom','Seg','Ter','Qua','Qui','Sex','Sáb','Dom'],
    monthNames: ['Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'],
    monthNamesShort: ['Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'],
    nextText: 'Próximo',
    prevText: 'Anterior',
  });
}

#gemfile
gem 'jquery-ui-rails'
#application.js
//= require jquery-ui
#application.css
*= require jquery-ui