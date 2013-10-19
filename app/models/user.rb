class User < ActiveRecord::Base

  belongs_to :room, counter_cache: true
  has_many :suggested_answers, dependent: :destroy

  def self.from_omniauth(auth_hash)
    auth = Authentication.find_or_create_by_hash(auth_hash)
    auth.user
  end

  def self.guest
    create(
      name: "#{I18n.t('users.guest_prefix')} #{rand 1e7}",
      guest: true
    )
  end

  def guest?
    !!guest
  end

  def join(room)
    room.users << self
  end

  def leave
    leaved_room = room
    room.users.delete self
    leaved_room
  end

end
