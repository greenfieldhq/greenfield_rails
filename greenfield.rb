def ruby_version
  "2.1.4"
end

def source_paths
  [File.expand_path("templates", File.dirname(__FILE__))]
end

template     'bin/setup'
run          'chmod a+x bin/setup'

copy_file    '.gitignore', '.gitignore', force: true

template     '.env.erb', '.env'

create_file  '.ruby-version', "#{ruby_version}\n"

template     'Gemfile.erb', 'Gemfile', force: true

template     'config/database.yml.erb', 'config/database.yml', force: true

copy_file    'config/secrets.yml', 'config/secrets.yml', force: true

copy_file    'config/routes.rb', 'config/routes.rb', force: true

inject_into_file 'config/application.rb',
  "    config.middleware.use ActionDispatch::Flash\n",
  after: "# config.i18n.default_locale = :de\n"

copy_file    'config/initializers/session_store.rb', 'config/initializers/session_store.rb', force: true
template     'config/initializers/rails_admin.rb.erb', 'config/initializers/rails_admin.rb'
copy_file    'config/initializers/sidekiq.rb'

generate :model, 'user first_name:string last_name:string email:string:uniq password_digest:string deleted_at:datetime --no-fixture --no-test-framework'
generate :model, 'api_key user:references access_token:string:uniq expired_at:datetime deleted_at:datetime --no-fixture --no-test-framework'

code_files = ['app/models/api_key.rb',
              'app/models/user.rb',
              'app/controllers/api/api_controller.rb',
              'app/controllers/api/sessions_controller.rb',
              'app/controllers/api/users_controller.rb',
              'app/controllers/application_controller.rb']
code_files.each do |file|
  copy_file file, file, force: true
end

run          'bundle exec rake db:create db:migrate db:seed'
