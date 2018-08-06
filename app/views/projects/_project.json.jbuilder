json.extract! project, :id, :name, :owner, :url, :num_stars, :created_at, :updated_at
json.url project_url(project, format: :json)
