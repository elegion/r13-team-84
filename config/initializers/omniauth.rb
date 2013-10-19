OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  creds = {
    facebook: {
      # https://developers.facebook.com/apps/1401972766703973
      key: ENV["FACEBOOK_KEY"] || "1401972766703973",
      secret: ENV["FACEBOOK_SECRET"] || "0c1cdb24a83dbbe66ab84bc78988a4c9"
    },
    twitter: {
      # https://dev.twitter.com/apps/5245792/
      key: ENV["TWITTER_KEY"] || "AffZ2mygy1ZVqH9zUobSg",
      secret: ENV["TWITTER_SECRET"] || "G2Zz1gX2w5EtYu5ZZrO0ng0C96tS773FkFAuHomp4Xw"
    },
    vkontakte: {
      key: ENV["VKONTAKTE_KEY"] || "3942448",
      secret: ENV["VKONTAKTE_SECRET"] || "MfF8v0UMjQQS15KvYURX"
    },
  }

  provider :facebook, creds[:facebook][:key], creds[:facebook][:secret],
    scope: "", display: "touch", secure_image_url: true, image_size: "normal",
    info_fields: "name,locale,username,timezone,updated_time,picture"
  provider :twitter, creds[:twitter][:key], creds[:twitter][:secret],
    secure_image_url: true, image_size: "bigger"
  provider :vkontakte, creds[:vkontakte][:key], creds[:vkontakte][:secret],
    scope: "", display: "mobile", image_size: "bigger"
end
