class ApiKeys::CreateApiKey
  def self.call(created_by:, name:)
    raise ::ApiErrors::ApiKeyNameTaken if ApiKey.exists?(name: name)
    ApiKey.create!(created_by: created_by, name: name)
  end
end
