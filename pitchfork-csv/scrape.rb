#!/usr/bin/ruby
require 'rubygems'
require 'json'
require_relative 'scrapers'

albums = []
ARGV.each do |file|
  if not File.exists?(file) or not File.readable?(file)
    print "Could not find or read #{file}\n"
    next
  end
  Scrapers.scrape_albums(open(file).read).each do |album|
    albums << album
  end
end
puts JSON.generate(albums)
