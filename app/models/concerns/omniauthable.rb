module Omniauthable
  extend ActiveSupport::Concern
  included do
    TEMP_EMAIL_PREFIX = 'change@me'
    TEMP_EMAIL_REGEX = /\Achange@me/

    def self.find_for_oauth(auth)
      authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
      return authorization.user if authorization

      email = auth.info[:email]
      user = User.where(email: email).first if email
      if user
        user.create_authorization(auth)
      else
        password = Devise.friendly_token
        user = User.new(email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com", password: password)
        user.skip_confirmation!
        user.save!
        user.create_authorization(auth)
      end
      user
    end

    def create_authorization(auth)
      self.authorizations.create(provider: auth.provider, uid: auth.uid)
    end

    def email_verified?
      self.email && self.email !~ TEMP_EMAIL_REGEX
    end
  end
end