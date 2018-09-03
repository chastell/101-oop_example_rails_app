# config/initializers/service_provider.rb
class ServiceProvider
  @services = {}

  def self.register(key, klass)
    return false if @services.key?(key) && !Rails.env.test?
    @services[key] = klass
  end

  def self.get(key)
    @services[key]
  end

  def self.[](key)
    get(key)
  end

  def self.finished_loading
    @services.freeze unless Rails.env.test?
  end
end

ServiceProvider.register :lock_service, LockService
ServiceProvider.finished_loading
