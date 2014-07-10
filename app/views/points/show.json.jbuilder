def date_for_chart(date)
  DateTime.parse(date).to_i * 1000
end

def value_before(value, original)
  list = Array.new(original)
  list << value
  list.sort!
  if list.index(value) > 0
    list.fetch(list.index(value) - 1, nil)
  else
    nil
  end
end

def value_after(value, original)
  list = Array.new(original)
  list << value
  list.sort!
  list.fetch(list.index(value) + 1, nil)
end

json.id @point.id
json.name @point.name

json.location do
  json.latitude @point.latitude
  json.longitude @point.longitude
end

data = {
    :total => [],
    :low => [],
    :medium => [],
    :high => []
}

@point.cloud_cover.each do |datum|
  date = date_for_chart(datum['from'])

  data[:total] << [date, datum['cloudiness'].to_f]
  data[:low] << [date, datum['lowClouds'].to_f]
  data[:medium] << [date, datum['mediumClouds'].to_f]
  data[:high] << [date, datum['highClouds'].to_f]
end

json.clouds data

rises = @point.sunrise.map { |s| date_for_chart(s['sun_rise']) }
sets  = @point.sunrise.map { |s| date_for_chart(s['sun_set']) }

bands = []

@point.sunrise.each do |datum|
  date = date_for_chart datum['date']

  band = {
      :from => value_before(date, sets),
      :to => value_after(date, rises),
      :color => '#cccccc'
  }

  if band[:from] && band[:to]
    bands << band
  end
end

json.bands bands

if current_user == @point.user
  json.owned true
end

json.privacy_flag @point.privacy_flag
