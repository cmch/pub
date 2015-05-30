require 'rubygems'
require 'nokogiri'
require 'json'
page = Nokogiri::HTML(open("/home/colin/projects/pub/pitchfork-csv/samples/album-reviews.html"))

albums=[]

page.search('div#main a').each { |node|
  artist = node.css('h1').inner_html
  next if artist.empty?
  albums << {"link" => node.attr('href'),
             "artist" => artist,
             "album" => node.css('h2').inner_html,
             "reviewer" => node.css('h3').inner_html.sub(/^by /,''),
             "date" => node.css('h4').inner_html
            }
}
puts JSON.generate(albums)
