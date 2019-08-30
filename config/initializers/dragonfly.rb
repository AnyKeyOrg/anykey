require 'dragonfly'

# Configure dragonfly app
app = Dragonfly[:images]
app.configure_with(:rails)
app.configure_with(:imagemagick)

# Extend active record
app.define_macro(ActiveRecord::Base, :image_accessor)
app.define_macro(ActiveRecord::Base, :file_accessor)

# Configure S3 datastore
app.datastore = Dragonfly::DataStorage::S3DataStore.new
app.datastore.configure do |c|
  c.bucket_name       = ENV['AWS_BUCKET']
  c.access_key_id     = ENV['AWS_ACCESS_KEY_ID']
  c.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  c.region            = ENV['AWS_REGION']
  c.url_scheme        = 'https'
end

# Serve thumbnails directly from S3
# Requires local caching with redis
app.configure do |c|
  c.define_url do |a, job, opts|
    if thumb = Thumbnail.find(job.serialize)
      a.datastore.url_for(thumb.uid)
    else
      a.server.url_for(job, opts)
    end
  end
  
  c.server.before_serve do |job, env|
    Thumbnail.create(:id => job.serialize, :uid => job.store)
  end
end
