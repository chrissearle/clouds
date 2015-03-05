require 'nokogiri'
require 'open-uri'

class LocationForecast
  def initialize(lat, lng)
    @doc = Nokogiri::XML(open("http://api.met.no/weatherapi/locationforecast/1.9/?lat=#{lat};lon=#{lng}"))
  end

  def forecast_data
    data = Array.new

    @doc.xpath('//time[@datatype="forecast" and location/cloudiness]').each do |time|
      datum = Hash.new
      datum['from'] = time['from']
      datum['to'] = time['to']

      ['cloudiness', 'lowClouds', 'mediumClouds', 'highClouds', 'fog'].each do |forecast_type|
        time.xpath("location/#{forecast_type}").each do |forecast|
          datum[forecast_type] = forecast['percent']
        end
      end

      data << datum
    end

    data
  end
end