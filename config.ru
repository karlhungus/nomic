$:.unshift File.expand_path('.', File.dirname(__FILE__))
require 'bundler/setup'
require 'server'

run App.new
