require 'chefspec'
require 'chefspec/berkshelf'

ALMA_10 = {
  platform: 'almalinux',
  version: '10',
}.freeze

ALMA_9 = {
  platform: 'almalinux',
  version: '9',
}.freeze

ALMA_8 = {
  platform: 'almalinux',
  version: '8',
}.freeze

DEBIAN_12 = {
  platform: 'debian',
  version: '12',
}.freeze

UBUNTU_2404 = {
  platform: 'ubuntu',
  version: '24.04',
}.freeze

ALL_DEBIAN = [
  DEBIAN_12,
  UBUNTU_2404,
].freeze

ALL_PLATFORMS = [
  ALMA_10,
  ALMA_9,
  ALMA_8,
  DEBIAN_12,
  UBUNTU_2404,
].freeze

RSpec.configure do |config|
  config.log_level = :warn
end
