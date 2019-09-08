module AffiliatesHelper
  
  def affiliate_image_src(affiliate, style = :thumb)
    if affiliate.image.present?
      affiliate.image_url(style)
    end  
  end
  
  def affiliate_links(affiliate)
    links = []
    if affiliate.website?
      links << ["&#xf57d;", affiliate.website]
    end
    if affiliate.twitch?
      links << ["&#xf1e8;", affiliate.twitch]
    end
    if affiliate.twitter?
      links << ["&#xf099;", affiliate.twitter]
    end
    if affiliate.facebook?
      links << ["&#xf082;", affiliate.facebook]
    end
    if affiliate.instagram?
      links << ["&#xf16d;", affiliate.instagram]
    end
    if affiliate.youtube?
      links << ["&#xf167;", affiliate.youtube]
    end
    # TODO: add ability to link discord and mixer
    # if affiliate.discord?
    #   links << ["&#xf392;", affiliate.discord]
    # end
    return links
  end

end
