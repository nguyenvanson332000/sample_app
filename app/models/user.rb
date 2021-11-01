class User < ApplicationRecord
  before_save{self.email = email.downcase}
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
end
