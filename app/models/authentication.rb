class Authentication < ActiveRecord::Base

   serialize :auth

   belongs_to :user

   validates :provider, :uid, presence: true
   validates :uid, uniqueness: { scope: :provider }
   validates :provider, uniqueness: { scope: :user_id }

   def self.find_or_create_by_hash(auth_hash)
     where(auth_hash.slice(:provider, :uid)).first_or_initialize.tap do |auth|
       auth.auth = auth_hash
       if auth.user.blank?
         auth.provider = auth_hash.provider
         auth.uid = auth_hash.uid
         auth.user = User.create do |u|
           u.name = auth.auth.info["name"]
         end
       end
       auth.save!
     end
   end

end
