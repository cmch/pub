#!/usr/bin/ruby
require 'rubygems'
require 'nokogiri'
require 'json'

def scrape_albums(page)
  page_albums=[]
  page.search('div#main a').each { |node|
    artist = node.css('h1').inner_html
    next if artist.empty?
    page_albums << {"link" => node.attr('href'),
               "artist" => artist,
               "album" => node.css('h2').inner_html,
               "reviewer" => node.css('h3').inner_html.sub(/^by /,''),
               "date" => node.css('h4').inner_html
              }
  }
  return page_albums
end

albums = []
ARGV.each do |file|
  if not File.exists?(file) or not File.readable?(file)
    print "Could not find or read #{file}\n"
    next
  end
  page = Nokogiri::HTML(open(file))
  scrape_albums(page).each do |album|
    albums << album
  end
end
puts JSON.generate(albums)
