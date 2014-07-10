json.array! @points do |point|
  json.id point.id
  json.name point.name
  json.privacy_flag point.privacy_flag
  json.latitude point.latitude
  json.longitude point.longitude
  json.path point_url(point, :format => :json)
end