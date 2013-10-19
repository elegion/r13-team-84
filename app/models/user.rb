class User < ActiveRecord::Base

  def self.from_omniauth(auth_hash)
    auth = Authentication.find_or_create_by_hash(auth_hash)
    auth.user
  end

end
