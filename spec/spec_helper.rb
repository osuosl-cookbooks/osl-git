require 'chefspec'
require 'chefspec/berkshelf'

ALMA_9 = {
  platform: 'almalinux',
  version: '9',
}.freeze

ALMA_8 = {
  platform: 'almalinux',
  version: '8',
}.freeze

CENTOS_7 = {
  platform: 'centos',
  version: '7',
}.freeze

DEBIAN_12 = {
  platform: 'debian',
  version: '12',
}.freeze

ALL_PLATFORMS = [
  ALMA_9,
  ALMA_8,
  CENTOS_7,
  DEBIAN_12,
].freeze

RSpec.configure do |config|
  config.log_level = :warn
end
