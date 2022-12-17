json.extract! event, :id, :name, :description, :date, :hour, :country, :state, :city, :is_virtual?, :created_at, :updated_at
json.url event_url(event, format: :json)
