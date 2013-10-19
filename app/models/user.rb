class User < ActiveRecord::Base

  belongs_to :room, counter_cache: true

  def self.from_omniauth(auth_hash)
    auth = Authentication.find_or_create_by_hash(auth_hash)
    auth.user
  end

end
