class ApiKey < ApplicationRecord
  before_validation :generate_key, on: :create

  validates :key, presence: true, uniqueness: true
  validates :name,
            presence: true,
            uniqueness: { message: "choose another unique name for api key" },
            allow_nil: false,
            length: { maximum: 100 }

  private

  def generate_key
    self.key ||= loop do
      # 64 chars = 256 bits of entropy, URL-safe, no padding
      random_key = SecureRandom.urlsafe_base64(48) # 64 chars
      random_key = "napi_#{random_key}"           # your prefix
      break random_key unless ApiKey.exists?(key: random_key)
    end
  end
end
