require 'addressable/uri'
require 'nokogiri'
require 'json'

#get address
def prompt_address
  puts "What's your address"
  address = gets.chomp
  address
end

#given the address, generate url
def generate_url(address)
  call_address = Addressable::URI.new(
     :scheme => "http",
     :host => "maps.googleapis.com",
     :path => "maps/api/geocode/json",
     :query_values => {:address => address,
       :sensor => 'false'}
   ).to_s
end

#http://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&sensor=false

#get lat/long from geocoding
#parse json









#get nearby places using Places
#display places





#get directions based on user input






