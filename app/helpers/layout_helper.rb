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
  
  def analytics
    if Rails.env.production?
script = <<-SCRIPT
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-74421707-2"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-74421707-2');
</script>
SCRIPT
      script.html_safe
    end
  end
    
end