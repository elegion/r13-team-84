class User < ActiveRecord::Base

  belongs_to :room, counter_cache: true
  has_many :suggested_answers, dependent: :destroy
  has_many :daily_statisticses, dependent: :destroy
  after_initialize :init

  def authentificate(auth_hash)
    auth = Authentication.find_or_create_by_hash(auth_hash, self)
    auth.user
  end

  def self.guest
    create(
      name: "#{I18n.t('users.guest_prefix')}#{rand 1e5}",
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
    room.tap { |r| r.users.delete(self) }
  end

  def heartbeat
    touch
  end

  private

  def init
    self.rating ||= Settings.rating.initial
  end

end
