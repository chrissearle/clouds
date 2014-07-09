class Point < ActiveRecord::Base
  belongs_to :user

 # attr_accessible :name, :latitude, :longitude, :privacy_flag


  scope :ordered, -> { order(:name) }
  scope :published, -> { where(:privacy_flag => true) }

  def self.cover_cache_key(point)
    "Cover:#{point.latitude}:#{point.longitude}"
  end

  def self.sunrise_cache_key(point)
    "Sunrise:#{point.latitude}:#{point.longitude}"
  end

  def cloud_cover
    cache_key = Point.cover_cache_key(self)

    cover = Rails.cache.read(cache_key)

    if cover.nil?
      Rails.logger.debug "No cache hit for #{cache_key} - retriving"

      refresh

      cover = Rails.cache.read(cache_key)
    end

    cover
  end

  def sunrise
    cache_key = Point.sunrise_cache_key(self)

    sunrise = Rails.cache.read(cache_key)

    if sunrise.nil?
      Rails.logger.debug "No cache hit for #{cache_key} - retriving"

      refresh

      sunrise = Rails.cache.read(cache_key)
    end

    sunrise
  end

  def refresh
    forecast_cache_key = Point.cover_cache_key(self)

    forecast = LocationForecast.new(self.latitude, self.longitude)

    cover = forecast.cloud_cover

    Rails.cache.write(forecast_cache_key, cover)

    from = Date.parse(cover.first['from'])

    to = from + 2

    sunrise = Sunrise.new(self.latitude, self.longitude, from, to)

    times = sunrise.times

    sunrise_cache_key = Point.sunrise_cache_key(self)

    Rails.cache.write(sunrise_cache_key, times)
  end

  def self.cache_content
    Point.all.map do |point|
      data = Hash.new
      data[:point] = point
      data[:cover] = Rails.cache.read(Point.cover_cache_key(point))
      data[:sunrise] = Rails.cache.read(Point.sunrise_cache_key(point))

      data
    end
  end

  def streetview_url(size)
    params = "location=#{self.latitude},#{self.longitude}&size=#{size}&sensor=false"

    unless ENV['GOOGLE_API_KEY'].blank?
      params = params + "&key=#{ENV['GOOGLE_API_KEY']}"
    end

    "http://maps.googleapis.com/maps/api/streetview?#{params}"
  end

  def location
    "#{self.latitude.round(5)}, #{self.longitude.round(5)}"
  end
end
