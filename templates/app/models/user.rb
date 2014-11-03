class User < ActiveRecord::Base
  has_many :api_keys

  validates :email, presence: true, uniqueness: true

  has_secure_password
  acts_as_paranoid

  def self.find_by_email(email)
    find_by('LOWER("users"."email") = LOWER(?)', email)
  end

  def active_api_key(token)
    api_keys.active.find_by(access_token: token)
  end
end
