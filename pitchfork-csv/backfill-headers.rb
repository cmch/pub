#! /usr/bin/ruby
require 'json'
require 'date'

ARGV.each do |file|
  if not File.exists?(file) or not File.readable?(file)
    print "Could not find or read #{file}\n"
    next
  end
  ary=JSON.parse(open(file).read)
  ary.each do |e|
    dt=e['date']
    if dt =~ /[A-Za-z]/
      e['date']=Date.strptime(dt,"%b %e, %Y").strftime("%Y-%m-%d")
    end
  end
  puts JSON.generate(ary)
end

  
