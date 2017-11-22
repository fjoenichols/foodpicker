require 'http'
require 'json'
require 'credentials'
require 'geocoder'

class SearchController < ApplicationController
    # Constants, do not change these
    API_HOST = "https://api.yelp.com"
    SEARCH_PATH = "/v3/businesses/search"
    TOKEN_PATH = "/oauth2/token"
    GRANT_TYPE = "client_credentials"
  
  def index
   
    @time = params[:time].to_i    
    if params[:foodtype].blank?
      case @time
      when 300 .. 1030
        @foodtype = "Breakfast"
      when 1031 .. 1530
        @foodtype = "Lunch"
      else  
        @foodtype = "Dinner"
      end
    else
      @foodtype = params[:foodtype]
    end
    
    if params[:city].blank? && params[:geoLocation].blank?
      @city = request.location.city + ", " + request.location.state
    elsif params[:city].blank?  
      @city = params[:geoLocation]
    else
      @city = params[:city]
    end

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
        limit: 50
      }

      response = HTTP.auth(bearer_token).get(url, params: params)
      response.parse
    end

    response = findPlaces(@foodtype, @city)
    if response["total"] <= 50
      @total_results = response["total"]
    else
        @total_results = 50
    end
    @randomNumber = rand(@total_results)
    pickedBusiness = response["businesses"][@randomNumber]
    if @total_results >= 1
      @business_url =  pickedBusiness["url"]
      @business_review_count = pickedBusiness["review_count"]
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
    rescue NoMethodError => e
        puts e
  end 
end
