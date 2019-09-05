module AffiliatesHelper
  
  def affiliate_image_src(affiliate, style = :thumb)
    if affiliate.image.present?
      affiliate.image_url(style)
    end  
  end

end
