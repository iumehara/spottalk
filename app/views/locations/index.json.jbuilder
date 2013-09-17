json.array!(@locations) do |location|
  json.extract! location, :name, :description, :lat, :long
  json.url location_url(location, format: :json)
end
