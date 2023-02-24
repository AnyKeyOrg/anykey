# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Stop rails from wrapping generated form fields with error tags
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.html_safe
end