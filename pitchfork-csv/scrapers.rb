require 'nokogiri'
require 'date'

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
                      "date" => Date.strptime(node.css('h4').inner_html,"%b %e, %Y").strftime("%Y-%m-%d")
                     }
    }
    return page_albums
  end

  def self.scrape_details(body)
    page = Nokogiri::HTML(body)
    page_details={}
    spans = page.search('span.score')
    unless spans[0].nil?
      page_details["score"] = spans[0].inner_html.strip
    end
    return page_details
  end
  
end
