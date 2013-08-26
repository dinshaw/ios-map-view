# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'

if ARGV.join(' ') =~ /spec/
  Bundler.require :default, :spec
else
  Bundler.require
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'rubymotion'
  app.files = (app.files - Dir.glob('./app/**/*.rb')) + Dir.glob("./lib/**/*.rb") + Dir.glob("./config/**/*.rb") + Dir.glob("./app/**/*.rb")
  app.frameworks += %w(CoreLocation MapKit QuartzCore AVFoundation CoreGraphics StoreKit)
end
