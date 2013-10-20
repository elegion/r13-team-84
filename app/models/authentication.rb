class Authentication < ActiveRecord::Base

  serialize :auth

  belongs_to :user

  validates :provider, :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }
  validates :provider, uniqueness: { scope: :user_id }

  def self.find_or_create_by_hash(auth_hash, user)
    where(auth_hash.slice(:provider, :uid)).first_or_initialize.tap do |auth|
      auth.provider = auth_hash.provider
      auth.uid = auth_hash.uid
      auth.auth = auth_hash
      if auth.user.present?
        user.destroy! if user.guest?
      else
        user.guest = false
        user.name = auth.auth.info["name"]
        user.avatar = auth.auth.info["image"]
        user.save!
        auth.user = user
      end
      auth.save!
    end
  end

end
