source "https://rubygems.org"

ruby File.read('.ruby-version').strip

gem "docker-template"

group :development do
  gem "envygeeks-rubocop"
  unless ENV["CI"] == "true"
    gem "travis"
    gem "pry"
  end
end
