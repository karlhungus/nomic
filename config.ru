$stdout.sync = true
$:.unshift File.expand_path('./lib', File.dirname(__FILE__))

require 'bundler/setup'
require 'nomic/app'
require 'nomic/rule'
require 'github_helper'

$:.unshift File.expand_path('./app', File.dirname(__FILE__))
Dir[File.join('./app', "*.rb")].each {|file| require File.basename(file) }

run Nomic::App.new
