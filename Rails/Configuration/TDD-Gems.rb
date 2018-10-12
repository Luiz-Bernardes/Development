# BASE
gem "rspec"
gem "rspec-rails", '~> 3.8'
---------------------------------------------------------------
# TEST MODEL > model
gem "factory_bot_rails"
gem "faker"
gem "rubocop-rspec"

# TEST CONTROLLER > controller
gem "rails-controller-testing"

# TEST VIEW > feature
gem "capybara"
gem "selenium-webdriver"
gem "chromedriver-helper"
---------------------------------------------------------------
# TEST API > request
gem "rspec-json_expectations"
gem "json_matchers"

# TEST HTTP
gem "httparty"
gem "webmock"
gem "vcr"

# SPRING
gem "spring-commands-rspec"

# ADITIONAL
gem "shoulda-matchers", '~> 3.1'

---------------------------------------------------------------