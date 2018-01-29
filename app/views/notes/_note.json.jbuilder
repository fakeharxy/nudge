json.extract! note, :id, :body, :todo_by, :last_seen, :created_at, :updated_at
json.url note_url(note, format: :json)
