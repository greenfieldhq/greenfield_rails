class Api::ApiController < ApplicationController
  before_action :authenticate_user_from_token!
end
