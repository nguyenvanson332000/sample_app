require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.eager_load = false
  config.action_mailer.default_url_options = {host: "localhost:3000" }
  # SMTP settings for gmail
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    user_name: ENV["USER_EMAIL"],
    password: ENV["USER_PASSWORD"],
    authentication: "plain",
    enable_starttls_auto: true
    }
end
