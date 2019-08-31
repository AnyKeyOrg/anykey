module LayoutHelper  

  def display_alerts
html = <<-HTML
<div class="flash" id="#{:alert}">
    <div class="text">
      #{flash[:alert]}
  </div>
</div>
HTML
    html.html_safe if flash[:alert]
  end
  
  def display_notices
html = <<-HTML
<div class="flash" id="#{:notice}">
    <div class="text">
      #{flash[:notice]}
  </div>
</div>
HTML
    html.html_safe if flash[:notice]
  end
    
end