module Players
  def minimum_goals
    filename = File.join("test", "fixtures", "files", "minimum_goals_data.json")
    response = IO.read(filename)
    JSON.parse(response).transform_keys(&:to_sym)
  end
end
