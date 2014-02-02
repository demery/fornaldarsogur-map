#!/usr/bin/env ruby

require 'nokogiri'

@names_auth_file = Nokogiri::XML(open File.expand_path(
	'../../xml/auth_files/names.xml', __FILE__))

@places_auth_file = Nokogiri::XML(open File.expand_path(
	'../../xml/auth_files/places.xml', __FILE__))

@repos_auth_file = Nokogiri::XML(open File.expand_path(
	'../../xml/auth_files/auth_repositories.xml', __FILE__))


@name_map = {}
@place_map = {}
@ns = { 't' => 'http://www.tei-c.org/ns/1.0' }

def find_person person_key
	@names_auth_file.xpath "//t:person[@xml:id='#{person_key}']", @ns
end

def get_person person_key
	@name_map[person_key] ||= find_person(person_key)
end

# Return a hash from the names.xml file with keys:
# 	
#   		:place_type
#  			:place_key
def find_place person_key
	if person_key =~ /ArnMag001/
		return { place_key: 'Copen01', place_type: 'residence' }
	end
	person = get_person person_key

	ptype = %w( residence death birth ).find { |ptype| 
		! person.xpath("t:#{ptype}[1]/t:placeName/t:settlement/@key", @ns).empty?	
	}

	if ptype
		place_key = person.xpath("t:#{ptype}[1]/t:placeName/t:settlement/@key", @ns)
		if ! place_key.empty?
			place_hash = {}
			place_hash[:place_type] = ptype
			place_hash[:place_key] = place_key.text.sub /^#/,''
			place_hash
		end
	end
end

def get_place person_key
	return nil if (person_key == 'unknown' || person_key == 'ambig')
	@place_map[person_key] || find_place(person_key)
end

# Return a hash from the places.xml file with keys:
#
#   		:geo
#   		:settlement
#   		:settlement_type
#       :country_key
#       :country_name
def place_details place_key
	place_node                     = @places_auth_file.xpath "//t:place[@xml:id='#{place_key}']", @ns
	details_hash                   = {}
	details_hash[:geo]             = place_node.xpath("t:location/t:geo", @ns).text()
	details_hash[:settlement]      = place_node.xpath("t:placeName[1]/t:settlement", @ns).text()
	details_hash[:settlement_type] = place_node.xpath("t:placeName[1]/t:settlement/@type", @ns).text()
	details_hash[:country_key]     = place_node.xpath("t:placeName[1]/t:country/@key", @ns).text()
	details_hash[:country_name]    = place_node.xpath("t:placeName[1]/t:country", @ns).text()
	details_hash
end

def add_place name, place
	place.each do |k,v|
		if v && !v.empty?
			name[k.to_s] = v
		end
	end
end

doc = Nokogiri::XML(open ARGV.shift)
doc.encoding = 'utf-8'

doc.xpath('//name').each do |name|
	person_key =  name['key'].sub /^#/, ''
	place = get_place person_key
	if place && place[:place_key]
		place.update place_details(place[:place_key])
	end
	# puts "#{person_key}\t#{place}"
	add_place name, place if place
	puts name
end