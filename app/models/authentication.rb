class Authentication < ActiveRecord::Base

   serialize :auth

   belongs_to :user

   validates :provider, :uid, presence: true
   validates :uid, uniqueness: { scope: :provider }
   validates :provider, uniqueness: { scope: :user_id }

end
