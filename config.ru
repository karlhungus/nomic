$stdout.sync = true
$:.unshift File.expand_path('./lib', File.dirname(__FILE__))

require 'bundler/setup'
require 'nomic/app'

run Nomic::App.new
