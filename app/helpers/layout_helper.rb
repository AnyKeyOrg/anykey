module LayoutHelper  
  def display_notifications
    [ :notice, :alert ].map do |status|
html = <<-HTML
<div class="flash" id="#{status}">
    <div class="text">
      #{flash[status]}
  </div>
</div>
HTML
      html.html_safe if flash[status]
    end.compact.join("\n").html_safe
  end
end