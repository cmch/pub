#!/usr/bin/ruby
require 'rubygems'
require 'nokogiri'
require 'json'

def scrape_details(page)
  page_details={}
  page_details["score"]=page.search('span.score').inner_html.strip
  return page_details
end

albums = {}
ARGV.each do |file|
  if not File.exists?(file) or not File.readable?(file)
    print "Could not find or read #{file}\n"
    next
  end
  page = Nokogiri::HTML(open(file))
  scrape_details(page).each do |detail|
    albums[file]=detail
  end
end
puts JSON.generate(albums)
