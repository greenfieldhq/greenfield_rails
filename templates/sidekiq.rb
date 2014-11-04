require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
  username == Rails.application.secrets.admin_user && password == Rails.application.secrets.admin_password
end
