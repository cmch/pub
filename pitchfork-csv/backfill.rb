#! /usr/bin/ruby
require 'json'
require 'date'

ARGV.each do |file|
  if not File.exists?(file) or not File.readable?(file)
    print "Could not find or read #{file}\n"
    next
  end
  hsh=JSON.parse(open(file).read)
  hsh.each_pair do |k,v|
    dt=hsh[k]['date']
    if dt =~ /[A-Za-z]/
      hsh[k]['date']=Date.strptime(dt,"%b %e, %Y").strftime("%Y-%m-%d")
    end
  end
  puts JSON.generate(hsh)
end

  
