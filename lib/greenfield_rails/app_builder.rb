module GreenfieldRails
  class AppBuilder < Rails::AppBuilder
    def readme
      template 'README.md.erb', 'README.md'
    end

    def replace_gemfile
      template 'Gemfile.erb', 'Gemfile', force: true
    end

    def set_ruby_to_version_being_used
      create_file '.ruby-version', "#{GreenfieldRails::RUBY_VERSION}\n"
    end

    def provide_setup_script
      copy_file 'setup', 'bin/setup'
      run 'chmod a+x bin/setup'
    end

    def setup_staging_environment
      copy_file 'staging.rb', 'config/environments/staging.rb'
    end

    def setup_api
      api_config = <<-RUBY

    # Set to false so we can use rails_admin.
    # Setting to false will add middleware that rails_admin needs (Flash, Session, etc).
    config.api_only = false
RUBY
      inject_into_file 'config/application.rb',
        api_config,
        after: "# config.i18n.default_locale = :de\n"
    end

    def setup_secrets
      copy_file 'secrets.yml', 'config/secrets.yml', force: true
    end

    def setup_dotfiles
      copy_file '.gitignore', '.gitignore', force: true
      template '.env.erb', '.env'
    end

    def setup_initializers
      template  'rails_admin.rb.erb', 'config/initializers/rails_admin.rb'
      copy_file 'sidekiq.rb', 'config/initializers/sidekiq.rb'
    end

    def remove_assets
      run 'rm -rf app/assets/javascripts'
      run 'rm -rf app/assets/stylesheets'
    end

    def remove_helpers
      run 'rm -rf app/heplers'
    end

    def remove_vendor
      run 'rm -rf vendor'
    end

    def generate_authentication
      generate :model, 'user first_name:string last_name:string email:string:uniq password_digest:string deleted_at:datetime --no-fixture --no-test-framework'
      generate :model, 'api_key user:references access_token:string:uniq expired_at:datetime deleted_at:datetime --no-fixture --no-test-framework'
    end

    def replace_generated_code
      copy_file 'api_key.rb', 'app/models/api_key.rb', force: true
      copy_file 'user.rb',    'app/models/user.rb',    force: true

      copy_file 'base_controller.rb',     'app/controllers/api/base_controller.rb'
      copy_file 'sessions_controller.rb', 'app/controllers/api/sessions_controller.rb'
      copy_file 'users_controller.rb',    'app/controllers/api/users_controller.rb'
    end

    def add_serializers
      copy_file 'user_serializer.rb', 'app/serializers/user_serializer.rb'
    end

    def setup_routes
      copy_file 'routes.rb', 'config/routes.rb', force: true
    end

    def use_postgres_config_template
      template 'database.yml.erb', 'config/database.yml', force: true
    end

    def create_database
      bundle_command 'exec rake db:create db:migrate db:seed'
    end
  end
end
