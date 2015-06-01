#!/usr/bin/ruby
require 'rubygems'
require 'nokogiri'
require 'json'
require_relative 'scrapers'

albums = {}
ARGV.each do |file|
  if not File.exists?(file) or not File.readable?(file)
    print "Could not find or read #{file}\n"
    next
  end
  Scrapers.scrape_details(open(file).read).each do |detail|
    albums[file]=detail
  end
end
puts JSON.generate(albums)
