module ApplicationHelper

  def signin_path(provider)
    "/auth/#{provider.to_s}"
  end

  def avatar(user)
    src = user.avatar || asset_path('default/avatar.png')
    image_tag(src, alt: "", title: user.name, class: 'user-avatar')
  end

  def color_class x
    "nickname-color-#{ x % 5 + 1 }"
  end

end
