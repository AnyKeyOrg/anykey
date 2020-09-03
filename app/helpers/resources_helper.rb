module ResourcesHelper
  
  def resources_metatags
    if controller.action_name == 'index'
      render(partial: 'resources/metatags')
    elsif controller.action_name == 'inclusion_101'
      render(partial: 'resources/metatags_inclusion_101')   
    elsif controller.action_name == 'keystone_code'
      render(partial: 'resources/metatags_keystone_code')
    end  
  end
  
end
