class ApiKey < ActiveRecord::Base
  belongs_to :user

  before_create :setup_access_token

  acts_as_paranoid

  def self.active
    where('expired_at >= ?', Time.zone.now)
  end

  acts_as_paranoid

  private

  def setup_access_token
    self.access_token = generate_access_token
    self.expired_at   = 30.days.from_now
  end

  def generate_access_token
    loop do
      access_token = SecureRandom.urlsafe_base64
      break access_token unless User.exists?(access_token: access_token)
    end
  end
end
