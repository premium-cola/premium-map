if @geocoded.nil?
  json.result "error"
else
  json.result "ok"
  json.coord do
     json.lat @geocoded.latitude
     json.lng @geocoded.longitude
  end
end
