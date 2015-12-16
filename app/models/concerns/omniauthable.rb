module Omniauthable
  extend ActiveSupport::Concern
  included do
    def self.find_for_oauth(auth)
      authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
      return authorization.user if authorization

      if auth.info.try(:email)
        email = auth.info[:email]
      else
        return false
      end

      user = find_or_create_user(email)
      return false unless user
      user.create_authorization(auth)
      user
    end

    def self.find_or_create_user(email)
      user = User.where(email: email).first
      unless user
        password = Devise.friendly_token[0, 20]
        user = User.new(email: email,
                        password: password,
                        password_confirmation: password
                       )
        return false unless user.save
      end
      user
    end

    def create_authorization(auth)
      authorizations.create(provider: auth.provider, uid: auth.uid)
    end
  end
end
