#!/usr/bin/ruby
require 'json'
require 'net/http'

headers=JSON.parse(ARGF.read)
review_paths=[]
base_url = "http://pitchfork.com"
base_dir = "samples/review-details"
if headers.is_a? Hash
  review_paths << headers["link"]
elsif headers.is_a? Array
  headers.map { |h| review_paths << h["link"] }
else
  puts "Invalid headers"
end
existing_files = Hash[`ls #{base_dir}`.split("\n").map { |f| [f,1] }]
review_paths = review_paths.shuffle(random: Random.new(1))
review_paths.each.with_index do |path, i|
  filename = path.split('/')[3] + ".html"
  if not existing_files.has_key?(filename)
    url = base_url + path
    sleep 1 + rand * 5
    die = false
    begin
      resp = Net::HTTP.get_response(URI(url))
    rescue StandardError => e
      sleep 30
      retr = (not die)
      die = true
      retry unless not retr
      puts e
      puts "Failed to get #{url}"
    end
    if not resp.code.to_i == 200
      puts resp.code
      puts resp.message
      puts "Failed to get #{url}"
      next
    end
    puts "#{base_dir}/#{filename}"
    File.write( "#{base_dir}/#{filename}", resp.body)
    existing_files[filename] = 1
  end
  puts "#{i} / #{review_paths.size}"
end
