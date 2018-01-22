Time.zone = 'Europe/Kiev'

SHOP_CONFIGS = YAML.load(File.open './config/shops.yml').deep_symbolize_keys.freeze
