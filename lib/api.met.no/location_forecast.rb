require 'nokogiri'
require 'open-uri'

class LocationForecast
  def initialize(lat, lng)
    @doc = Nokogiri::XML(open("http://api.met.no/weatherapi/locationforecast/1.8/?lat=#{lat};lon=#{lng}"))
  end

  def cloud_cover
    data = Array.new

    @doc.xpath('//time[@datatype="forecast" and location/cloudiness]').each do |time|
      datum = Hash.new
      datum['from'] = time['from']
      datum['to'] = time['to']

      ['cloudiness', 'lowClouds', 'mediumClouds', 'highClouds'].each do |cloud_type|
        time.xpath("location/#{cloud_type}").each do |cloud|
          datum[cloud_type] = cloud['percent']
        end
      end

      data << datum
    end

    data
  end
end