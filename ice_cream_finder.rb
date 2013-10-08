require 'addressable/uri'
require 'nokogiri'
require 'json'
require 'rest-client'

def execute
  #origin
  address = prompt_address
  adr_url = generate_geo_url(address)

  #nearest ice cream
  coord = get_coordinates(adr_url)
  places_url = generate_places_url(coord)
  ice_cream_address = get_nearby_places(places_url)

  #get directions
  directions_url = generate_directions_url(address, ice_cream_address)
  directions = get_directions(directions_url)

  puts "Directions to the nearest ice cream shop.\n\n\n"
  puts directions
end

#get address
def prompt_address
  puts "What's your address"
  address = gets.chomp
  address
end

#given the address, generate url
def generate_geo_url(address)
  call_address = Addressable::URI.new(
     :scheme => "https",
     :host => "maps.googleapis.com",
     :path => "maps/api/geocode/json",
     :query_values => {:address => address,
       :sensor => 'false'}
   ).to_s
end

#get lat/long from geocoding
#parse json
def get_coordinates(url)
  json_response = RestClient.get(url)
  addr_obj = JSON.parse(json_response)
  coord = addr_obj["results"][0]["geometry"]["location"] #gets the lat/long hash
  coord.values.join(",")
end

#get nearby places using Places
#display places
def generate_places_url(coordinates)
  call_address = Addressable::URI.new(
     :scheme => "https",
     :host => "maps.googleapis.com",
     :path => "maps/api/place/nearbysearch/json",
     :query_values => {
       :location => coordinates,
       :rankby => "distance",
       :types => "food",
       :keyword => "ice cream",
       :sensor => 'false',
       :key => "AIzaSyD2JOxpVx-nJo8W4k1IaZj--D2XtECZ7Ng"}
   ).to_s
end

def get_nearby_places(url)
  json_response = RestClient.get(url)
  places_obj = JSON.parse(json_response)

  closest_location = places_obj["results"][0]
  puts 'I found one ice cream shop near you.'
  puts closest_location['name']
  puts closest_location['vicinity']
  #p closest_location['geometry']['location']
  closest_location['vicinity']
end

def generate_directions_url(start_loc, end_loc)
  call_address = Addressable::URI.new(
     :scheme => "https",
     :host => "maps.googleapis.com",
     :path => "maps/api/directions/json",
     :query_values => {
       :origin => start_loc,
       :destination => end_loc,
       :sensor => 'false',
       :mode => 'walking'
     }
   ).to_s
end


def get_directions(url)
  json_response = RestClient.get(url)
  direction_obj = JSON.parse(json_response)

  steps_arr = []

  direction_obj["routes"].first['legs'].first['steps'].each do |step|
    #get rid of html tags and save it in the array of steps
    steps_arr << Nokogiri::HTML(step['html_instructions']).text
  end

  steps_arr
end

if __FILE__ == $PROGRAM_NAME
  execute
end