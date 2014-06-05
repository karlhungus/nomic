$:.unshift File.expand_path('.', File.dirname(__FILE__))
require 'bundler/setup'
require 'nomic'

run Nomic.new
