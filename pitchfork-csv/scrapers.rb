require 'nokogiri'

module Scrapers
  def self.scrape_albums(body)
    page = Nokogiri::HTML(body)
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

  def self.scrape_details(body)
    page = Nokogiri::HTML(body)
    page_details={}
    page_details["score"]=page.search('span.score').inner_html.strip
    return page_details
  end
  
end
