module StoriesHelper
  
  def stories_metatags
    if controller.action_name == 'index'
      render(partial: 'stories/metatags')
    elsif controller.action_name == 'changemakers'
      render(partial: 'stories/metatags_changemakers')
    end
  end
  
  def story_image_src(story, style = :thumb)
    if story.image.present?
      story.image_url(style)
    else
      image_path("/images/default-story-image.jpg")
    end
  end
  
end
