#!/usr/bin/env ruby

require 'nokogiri'

puts "<blergl>"

ARGV.each do |file|
  doc = Nokogiri::XML(open file)
  puts doc.xpath '//name'
end
puts "</blergl>"