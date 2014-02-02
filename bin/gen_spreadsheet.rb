#!/usr/bin/env ruby

require 'nokogiri'
require 'set'

NS = { 't' => 'http://www.tei-c.org/ns/1.0' }

ALL_NAMES_XML = Nokogiri::XML(open File.expand_path(
  '../../data/names_with_places.xml', __FILE__))

REPOS_XML = Nokogiri::XML(open File.expand_path(
  '../../xml/auth_files/auth_repositories.xml', __FILE__))

NAME_NODES = ALL_NAMES_XML.xpath('//name[@geo]')

MANUSCRIPT_KEYS = Set.new

def settlement_name name_node
  if name_node.xpath('@place_key').text =~ /Reykj/
    return 'Reykjavík'
  end
  name = name_node.xpath("@settlement", NS).text
  if name.empty?
    name = name_node.xpath("@country_key")
  end
  name
end

name_nodes = ALL_NAMES_XML.xpath('//name[@geo]')

name_nodes.each do |node|
  MANUSCRIPT_KEYS << node.xpath("@msID").text
end

tx_id = 1

puts %w(ID Title Type Lat Long Location).join ','

MANUSCRIPT_KEYS.each do |ms_id|
  name_node         = ALL_NAMES_XML.xpath("//name[@geo and @msID='#{ms_id}'][1]")
  repo_key          = name_node.xpath("@repositoryID", NS).text.sub /^#/, ''
  repo_node         = REPOS_XML.xpath("//t:org[@xml:id='#{repo_key}']", NS)
  source            = settlement_name(name_node)
  dest              = repo_node.xpath("t:place/t:settlement", NS).text
  title             = name_node.xpath("@msTitle", NS).text
  source_row = []

  source_row << tx_id
  source_row << title
  source_row << 'Source'
  source_row << name_node.xpath("@geo", NS).text.split
  source_row << source
  
  puts source_row.flatten.join ','

  dest_row = []

  dest_row << tx_id
  dest_row << title
  dest_row << 'Destination'
  dest_row << repo_node.xpath('t:place/t:location/t:geo', NS).text.split
  dest_row << dest

  puts dest_row.flatten.join ','

  # do this last
  tx_id += 1
end