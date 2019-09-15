module StoriesHelper
  
  def stories_metatags
    render(partial: 'stories/metatags')
  end
  
  def story_image_src(story, style = :thumb)
    if story.image.present?
      story.image_url(style)
    else
      image_path("/images/default-story-image.jpg")
    end
  end
  
end
