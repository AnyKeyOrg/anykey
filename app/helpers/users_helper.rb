module UsersHelper
  
  def user_image_src(user, style = :thumb)
    if user.image.present?
      user.image_url(style)      
    else
      image_path("/images/default-user-image.jpg")
    end  
  end
   
end
