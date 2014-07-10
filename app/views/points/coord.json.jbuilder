json.name @point.name

json.location do
  json.latitude @point.latitude
  json.longitude @point.longitude
end

json.zoom 7