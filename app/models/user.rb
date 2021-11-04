class User < ApplicationRecord
  before_save{email.downcase!}
  validates :name, presence: true,
                   length: {maximum: Settings.max_length.name_50}
  VALID_EMAIL_REGEX = /\A[\w\-.+]+@[a-z\-\d.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true,
                    length: {maximum: Settings.max_length.email_255},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  has_secure_password
  validates :password, presence: true,
                       length: {minimum: Settings.min_length.password_6}

  # Returns the hash digest of the given string.
  def self.digest string
    cost =  if ActiveModel::SecurePassword.min_cost
              BCrypt::Engine::MIN_COST
            else
              BCrypt::Engine.cost
            end
    BCrypt::Password.create string, cost: cost
  end
end
