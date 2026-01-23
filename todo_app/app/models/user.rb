class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :boards, dependent: :destroy
  has_many :lists, through: :boards
  has_many :tasks, through: :lists
  validates :name, presence: true

  def self.from_google(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.email = auth.info.email
      user.name  = auth.info.name if user.respond_to?(:name)
      user.provider = auth.provider
      user.uid = auth.uid

      credentials = auth.credentials
      user.token = credentials.token
      user.refresh_token = credentials.refresh_token if credentials.refresh_token.present?
      user.token_expires_at = Time.at(credentials.expires_at) if credentials.expires_at.present?

      user.password = Devise.friendly_token[0, 20] if user.encrypted_password.blank?
      user.save!
    end
  end
  
end
