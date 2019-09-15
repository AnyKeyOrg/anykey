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
    if affiliate.discord?
      links << ["&#xf392;", affiliate.discord]
    end
    # TODO: find away to create the actual Mixer icon
    if affiliate.mixer?
      links << ["&#xf00d", affiliate.mixer]
    end
    return links
  end
  
  def affiliates_metatags
    render(partial: 'affiliates/metatags')
  end

end
