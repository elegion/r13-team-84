class Authentication < ActiveRecord::Base

   serialize :auth

   belongs_to :user

   validates :provider, :uid, presence: true
   validates :uid, uniqueness: { scope: :provider }
   validates :provider, uniqueness: { scope: :user_id }

   def self.find_or_create_by_hash(auth_hash)
     where(auth_hash.slice(:provider, :uid)).first_or_initialize.tap do |auth|
       auth.provider = auth_hash.provider
       auth.uid = auth_hash.uid
       auth.auth = auth_hash
       auth.user = User.new if auth.user.blank?
       auth.user.name = auth.auth.info["name"]
       auth.user.save!
       auth.save!
     end
   end

end
