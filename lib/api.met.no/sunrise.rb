require 'nokogiri'
require 'open-uri'

class Sunrise
  def initialize(lat, lng, from, to)
    @doc = Nokogiri::XML(open("http://api.met.no/weatherapi/sunrise/1.0/?lat=#{lat};lon=#{lng};from=#{from};to=#{to}"))
  end

  def times
    data = Array.new

    @doc.xpath('//time').each do |time|
      datum = Hash.new
      datum['date'] = time['date']


      ['sun', 'moon'].each do |body|
        time.xpath("location/#{body}").each do |body_item|
          datum["#{body}_rise"] = body_item['rise']
          datum["#{body}_set"] = body_item['set']

          if (!body_item['phase'].blank?)
            datum["#{body}_phase"] = body_item['phase']
          end
        end
      end

      data << datum
    end

    data
  end
end