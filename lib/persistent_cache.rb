# Persistent cache that uses redis
class PersistentCache
  def self.write(key, value, expires_in:)
    cache.set(key, value)
    cache.expire(key, expires_in)
    value
  end

  def self.read(key)
    cache.get(key)
  end

  def self.cache
    @cache ||= Redis.new
  end
end
