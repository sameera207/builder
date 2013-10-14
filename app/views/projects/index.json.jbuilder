json.array!(@projects) do |project|
  json.extract! project, :name, :local_git_path
  json.url project_url(project, format: :json)
end
