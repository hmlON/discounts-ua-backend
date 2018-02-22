module PeriodicAction
  def self.not_often_than(interval, key)
    key = ActiveSupport::Cache.expand_cache_key(key) # converts [1,2,3] to "1/2/3"
    return if PersistentCache.read(key)

    PersistentCache.write(key, true, expires_in: interval.to_i)

    yield
  end
end
