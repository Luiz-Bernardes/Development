# gemfile
gem 'select2-rails'

# application.js
//= require select2

$(function() {
  selecttext();
});

function selecttext(){
  $( "#combobox" ).select2({
      theme: "bootstrap"
  });
}

# application.css
*= require jquery-ui
*= require font-awesome
*= require bootstrap_and_overrides
*= require select2
*= require select2-bootstrap
*= require_tree .
*= require_self
*/