json.extract! image, :id, :data, :content_type, :created_at, :updated_at
json.url image_url(image, format: :json)
