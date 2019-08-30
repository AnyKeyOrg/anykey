# NOT ACTIVE RECORD
# Redis store to keep track of thumbnail URLs for images processed with Dragonfly
# and served straight from S3 instead of the server
class Thumbnail

  attr_accessor :id, :uid
  class_attribute :redis

  self.redis ||= Redis::Namespace.new('thumbnails', :redis => $redis)

  def self.find(id)
    if uid = redis[id]
      self.new(:id => id, :uid => uid)
    end
  end

  def self.create(params = { })
    self.new(params).save
  end

  def self.all
    redis.keys.collect { |k| find(k) }
  end

  def self.destroy_all
    all.each(&:destroy)
  end

  def initialize(params = { })
    self.id  = params[:id]
    self.uid = params[:uid]
  end

  def redis
    self.class.redis
  end

  def save
    if id && uid
      redis[id] = uid
      return id
    else
      return false
    end
  end

  def destroy
    Dragonfly.app.datastore.destroy(uid)
    redis.del(id)
  end
end
