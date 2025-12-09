class ApiKey < ApplicationRecord
  before_validation :generate_key, on: :create
  before_validation :set_default_name, on: :create

  validates :key, presence: true, uniqueness: true

  private

  def generate_key
    self.key ||= loop do
      # 64 chars = 256 bits of entropy, URL-safe, no padding
      random_key = SecureRandom.urlsafe_base64(48) # 64 chars
      random_key = "napi_#{random_key}"           # your prefix
      break random_key unless ApiKey.exists?(key: random_key)
    end
  end

  def set_default_name
    self.name ||= "key#{ApiKey.count + 1}"
  end
end
