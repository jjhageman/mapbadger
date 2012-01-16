load 'deploy' if respond_to?(:namespace) # cap2 differentiator

env = ENV['RUBBER_ENV'] ||= (ENV['RAILS_ENV'] || 'production')
root = File.dirname(__FILE__)

# this tries first as a rails plugin then as a gem
$:.unshift "#{root}/vendor/plugins/rubber/lib/"
require 'rubber'

Rubber::initialize(root, env)
require 'rubber/capistrano'

Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'
load 'deploy/assets'