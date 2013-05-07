source 'https://rubygems.org'
ruby "1.9.3"

gem 'rails', '3.2.13'
gem 'pg' # for heroku

gem 'carrierwave'

gem 'fog'
gem 'haml-rails'
gem 'jquery-rails'
gem 'zencoder'
gem 'mini_magick'
gem 'redactor-rails'
gem 'simple_form'
gem 'jquery-fileupload-rails'
# gem 'client_side_validations'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'zurb-foundation', '~> 4.0.0'
end

group :development do
  gem 'binding_of_caller'
  gem 'better_errors'
  gem 'quiet_assets'

end

gem 'thin'

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'factory_girl_rails'
  gem 'dotenv-rails'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'timecop'
end
