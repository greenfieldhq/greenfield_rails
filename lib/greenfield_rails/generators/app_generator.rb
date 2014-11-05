require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module GreenfieldRails
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database,
      type: :string,
      aliases: '-d',
      default: 'postgresql',
      desc: "Preconfigure for selected database (options: #{DATABASES.join('/')})"

    def finish_template
      invoke :greenfield_customization
      super
    end

    def greenfield_customization
      invoke :customize_gemfile
      invoke :setup_development_environment
      invoke :setup_test_environment
      invoke :setup_staging_environment
      invoke :setup_production_environment
      invoke :configure_app
      invoke :remove_generated_files
      invoke :setup_authentication
      invoke :setup_database
    end

    def customize_gemfile
      build :replace_gemfile
      build :set_ruby_to_version_being_used

      bundle_command 'install'
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :provide_setup_script
    end

    def setup_test_environment
      say 'Setting up the test environment'
      # TODO we can add test customizations here
    end

    def setup_staging_environment
      say 'Setting up the staging environment'
      build :setup_staging_environment
    end

    def setup_production_environment
      say 'Setting up the production environment'
      # TODO we can add production customizations here
    end

    def configure_app
      say 'Configuring app'
      build :setup_api
      build :setup_secrets
      build :setup_dotfiles
      build :setup_initializers
    end

    def remove_generated_files
      build :remove_assets
      build :remove_helpers
      build :remove_vendor
    end

    def setup_authentication
      say 'Setting up authentication'
      build :generate_authentication
      build :replace_generated_code
      build :add_serializers
      build :setup_routes
    end

    def setup_database
      build :use_postgres_config_template
      build :create_database
    end

    def outro
      say 'Congratulations! Your app is now Green.'
    end

    def run_bundle
      # Let's not: We'll bundle manually at the right spot
    end

    protected

    def get_builder_class
      GreenfieldRails::AppBuilder
    end
  end
end
