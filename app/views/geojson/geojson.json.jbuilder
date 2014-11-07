json.type "FeatureCollection"

json.features @addresses do |json, address|
  json.type "Feature"

  json.properties do
    name = ""
    if params[:type] == "s" 
      name += "#{address.first_name} #{address.last_name}".strip
      name += " - " if name.length > 0 && !address.company.blank?
    end
    name += address.company if address.company

    json.company name

    if params[:type] != "s"
      json.street address.street
      json.city address.city
      json.zipcode address.zipcode
    end
    

    json.country address.country
    json.web address.web
    json.email address.email
    json.telephone address.telephone

    json.products address.products

    json.distance address.distance(@geopoint)
  end

  json.geometry do |geo|
    geo.type "Point"
    geo.coordinates [address.longitude, address.latitude]
  end

end
