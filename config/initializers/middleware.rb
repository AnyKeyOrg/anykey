middleware = Anykey::Application.config.middleware

# Sets up Dragonfly as middleware, but removes caching from environments where it's redundant
middleware.insert 0, Rack::Cache, {
  :verbose     => true,
  :metastore   => CGI.escape("file:#{Rails.root}/tmp/dragonfly/cache/meta"),
  :entitystore => CGI.escape("file:#{Rails.root}/tmp/dragonfly/cache/body")
}

middleware.insert_after Rack::Cache, Dragonfly::Middleware, :images