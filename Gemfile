source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "active_model_serializers", "0.8.3"
gem "httparty"
gem "omniauth-google-oauth2"
gem "pg", "~> 0.18"
gem "puma", "~> 3.7"
gem "rails", "~> 5.1.1"
gem "versionist"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.5"
  gem "warden"
  gem "webmock"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "json_spec"
  gem "shoulda-matchers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
