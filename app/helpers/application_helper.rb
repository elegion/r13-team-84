module ApplicationHelper

  def signin_path(provider)
    "/auth/#{provider.to_s}"
  end

  def avatar(user)
    src = user.avatar || '/assets/default/avatar.png'
    image_tag(src, alt: "", title: user.name, class: 'user-avatar')
  end

end
