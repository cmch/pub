#!/usr/bin/ruby
require 'logger'
require 'aws-sdk'
require 'json'
require 'net/http'
require_relative 'scrapers'
require 'date'

bucket_name = "pitchfork-csv"
headers_key = "review-headers.json"
data_bucket = "pitchfork-csv-review-data"
log = Logger.new(STDOUT)

# get latest header file from s3
s3 = Aws::S3::Client.new(region: 'us-west-2')
header_object = s3.get_object(bucket: bucket_name, key: headers_key)
log.info("pulled headers from  #{bucket_name}/#{headers_key} - size #{header_object.content_length}")
header_list = JSON.parse(header_object.body.read)

# get reviews front page from pitchfork
base_url = "http://pitchfork.com"
reviews_path = "/reviews/albums/"
die = false
begin
  headers_resp = Net::HTTP.get_response(URI(base_url+reviews_path))
  die = false
rescue SocketError => e
  sleep 30
  retr = (not die)
  die = true
  retry if retr
  puts e
end
return 1 if die
if not headers_resp.code.to_i == 200
  die = true
  puts "Unexpected response getting review headers: #{headers_resp.code} #{headers_resp.message}"
end
return 1 if die
log.info("pulled pitchfork reviews page - size #{headers_resp.body.bytesize}")

# build set of new review headers
today_headers = Scrapers.scrape_albums(headers_resp.body)

# append new headers to master list
unique_headers = {}
header_list.each do |a|
  next unless a.is_a?(Hash)
  unique_headers[a['link']] = true
end
fresh_headers = []
today_headers.map do |a|
  if not unique_headers[a['link']]
    fresh_headers << a
    header_list << a
  end
end
log.info("found #{fresh_headers.size} fresh reviews")

# upload to s3
s3.put_object(body: JSON.generate(header_list), bucket: bucket_name, key: headers_key)

# download review details for new albums
review_data = JSON.parse(s3.get_object(bucket: data_bucket, key: "review-data.json").body.read)
review_keys = s3.list_objects(bucket: data_bucket, max_keys: 1000)
names = {}
loop do
  review_keys.contents.each do |o|
    names[o.key] = true
  end
  break unless review_keys.is_truncated
  review_keys = s3.list_objects(bucket: data_bucket, max_keys: 1000, marker: review_keys.contents[-1].key)
end
today_headers.each do |h|
  link =  h['link'].split('/')[3]
  next if names[link]
  url = base_url + h['link']
  log.info("pulling #{url}")
  sleep 1 + rand * 5
  begin
    resp = Net::HTTP.get_response(URI(url))
  rescue SocketError => e
    sleep 30
    retr = (not die)
    die = true
    retry unless not retr
    puts e
    puts "Failed to get #{url}"
  end

  if resp.is_a? Net::HTTPRedirection then
    location = resp['location']
    log.warn "redirected to #{location}"
    resp = Net::HTTP.get_response(URI(location))
  end

  if not resp.code.to_i == 200
    puts resp.code
    puts resp.message
    puts "Failed to get #{url}"
    next
  end
  # update master details file
  link =  h['link'].split('/')[3]
  review_data[link] = Scrapers.scrape_details(resp.body)
  # upload reviews to s3
  s3.put_object(body: resp.body, bucket: data_bucket, key: link)
end

# upload master details to s3
s3.put_object(body: JSON.generate(review_data), bucket: data_bucket, key: "review-data.json")

# stitch headers and details together and upload to the web folder
merged = {}
header_list.each do |h|
  key=h['link'].split('/')[3]
  merged[key]=h
  h.delete 'link'
  if review_data.has_key? key
    review_data[key].each_pair do |k,v|
      merged[key][k]=v
    end
  else
    log.error("Failed to find #{key} in review_data hash")
  end
end
web_bucket='pitchfork-csv-web'
web_key='albums.json'
s3.put_object(body: JSON.generate(merged), bucket: web_bucket, key: web_key, content_type: 'application/json')
s3.put_object_acl(bucket: web_bucket, key: web_key, grant_read:'uri="http://acs.amazonaws.com/groups/global/AllUsers"')
