source 'http://ruby.taobao.org/'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem "analytics-ruby"
gem "bcrypt-ruby"
gem "bourbon"
gem "slim-rails"
gem "simple_form", git: "https://github.com/plataformatec/simple_form"
gem "uuidtools"
gem "mongo"
gem 'mongoid', git: 'git://github.com/mongoid/mongoid.git'
gem 'mongoid_auto_increment_id', "0.6.2"
# 全文搜索引擎
gem 'sunspot_rails'
gem 'sunspot_solr' # optional pre-packaged Solr distribution for use in development
# API系统
gem "grape"
gem 'grape-entity'
# 分页系统
gem "will_paginate_mongoid"
# 图片附件
gem "carrierwave"
gem "carrierwave-mongoid", :require => 'carrierwave/mongoid'
gem "mini_magick"
gem 'bson_ext'
# rails admin
gem 'rails_admin', git: 'https://github.com/sferik/rails_admin'

group :development do
  gem "rspec-rails"
  gem "guard-rspec"
  gem 'better_errors'
  gem "binding_of_caller"
  gem 'debugger', group: [:development, :test]
end

group :test do
  gem "capybara"
  gem "launchy"
  gem "factory_girl_rails"
  gem "database_cleaner"
end

group :production do
  gem "rails_12factor"
end
