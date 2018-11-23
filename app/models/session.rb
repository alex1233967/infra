class Session < ActiveRecord::Base
  before_save { self.name = name.downcase }
  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }

  has_secure_password
# validates :password, length: { minimum: 8 }

  VALID_ALLOWED_PHONES_REGEX=/\A((\d{3}|VoiceMessage))(, ?((\d{3}|VoiceMessage)))*\z/
  validates :allowed_phones, format: { with: VALID_ALLOWED_PHONES_REGEX }

  def Session.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Session.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def update_attributes_only_if_not_blank(attributes)
    attributes.each { |k,v| attributes.delete(k) if v.blank? }
    update_attributes(attributes)
  end

  private

    def create_remember_token
      self.remember_token = Session.encrypt(Session.new_remember_token)
    end
end
