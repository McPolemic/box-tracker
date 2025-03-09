json.extract! photo, :id, :data, :content_type, :created_at, :updated_at
json.url photo_url(photo, format: :json)
