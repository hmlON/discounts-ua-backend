class ShopsConfigs
  include Enumerable

  def initialize(path_to_config:)
    @shop_configs = YAML.load(File.open path_to_config).deep_symbolize_keys
  end

  def each
    shop_configs.each {|config| yield config}
  end

  private

  attr_reader :shop_configs
end

