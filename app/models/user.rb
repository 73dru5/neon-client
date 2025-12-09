class User < ApplicationRecord
  self.primary_key = :id
  has_many :api_keys, dependent: :destroy
end
