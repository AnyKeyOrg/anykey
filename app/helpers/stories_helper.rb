module StoriesHelper
  
  def story_image_src(story, style = :thumb)
    if story.image.present?
      story.image_url(style)
    end  
  end

end
