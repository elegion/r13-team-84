OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Settings.facebook.key, Settings.facebook.secret,
    scope: "", display: "touch", secure_image_url: true, image_size: "normal",
    info_fields: "name,locale,username,timezone,updated_time,picture"
  provider :twitter, Settings.twitter.key, Settings.twitter.secret,
    secure_image_url: true, image_size: "bigger"
  provider :vkontakte, Settings.vkontakte.key, Settings.vkontakte.secret,
    scope: "", display: "mobile", image_size: "bigger"
end
