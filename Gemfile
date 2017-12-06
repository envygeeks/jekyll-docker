source "https://rubygems.org"

gem "docker-template"
group :development do
  unless ENV["CI"] == "true"
    gem "travis"
    gem "pry"
  end
end
