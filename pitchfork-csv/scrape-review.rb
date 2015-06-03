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
  albums[file]=Scrapers.scrape_details(open(file).read)
end
puts JSON.generate(albums)
