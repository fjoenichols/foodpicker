require 'http'
require 'json'
require 'credentials'

class SearchController < ApplicationController
    # Constants, do not change these
    API_HOST = "https://api.yelp.com"
    SEARCH_PATH = "/v3/businesses/search"
    TOKEN_PATH = "/oauth2/token"
    GRANT_TYPE = "client_credentials"
  
  def index
    @foodtype = params[:foodtype]
    @city = params[:city]
    
    def bearer_token
      url = "#{API_HOST}#{TOKEN_PATH}"
      params = {
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
        grant_type: GRANT_TYPE
      }

      response = HTTP.post(url, params: params)
      parsed = response.parse

      "#{parsed['token_type']} #{parsed['access_token']}"
    end

    def findPlaces(term, location)
      url = "#{API_HOST}#{SEARCH_PATH}"
      params = {
        term: term,
        location: location,
        sort_by: "rating",
        price: "1,2",
        radius: 4825,
        open_now: true,
      }

      response = HTTP.auth(bearer_token).get(url, params: params)
      response.parse
    end

    response = findPlaces(@foodtype, @city)
    @total_results = response["total"]
    randomNumber = rand(@total_results+1)
    pickedBusiness = response["businesses"][randomNumber]
    if @total_results >= 1
      @business_name =  pickedBusiness["name"]
      @business_address = pickedBusiness["location"]["address1"].to_s + " " + pickedBusiness["location"]["address2"].to_s + " " + pickedBusiness["location"]["address3"].to_s
      @business_city = pickedBusiness["location"]["city"].to_s + ", " + pickedBusiness["location"]["state"].to_s + " " + pickedBusiness["location"]["zipcode"].to_s
      @business_phone = pickedBusiness["display_phone"]
      @business_rating = pickedBusiness["rating"]
      @business_image = pickedBusiness["image_url"]
    else
      @business_name = "No Results"
      @business_city = ""
      @business_phone = ""
      @business_rating = ""
      @business_image = ""
    end 
  end
  
  def pick
  end
end
