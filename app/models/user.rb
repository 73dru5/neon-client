class User < ApplicationRecord
  def add_auth_account(auth)
    new_account = {
      provider: auth.provider,
      uid: auth.uid,
      image: auth.image,
      name: auth.name,
      login: auth.login,
      email: auth.email
    }.compact
    exists = auth_accounts.any? { |acc| acc["provider"] == auth.provider }
    debugger
    self.auth_accounts << new_account unless exists
  end
end
