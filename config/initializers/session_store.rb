# A browser drops a cookie whose domain isn't the origin host or a parent of it, so a
# deployment on some other host needs to say so or no session is ever stored.
domain = if Rails.env.production? || Rails.env.sandbox?
  ENV["SESSION_COOKIE_DOMAIN"].presence || "bikeindex.org"
elsif Rails.env.test?
  nil
else
  "localhost"
end

# Include port in session key to prevent collisions across dev workspaces
key = if Rails.env.production? || Rails.env.sandbox?
  "_bikeindex_session"
else
  port = ENV.fetch("DEV_PORT", 3042)
  "_bikeindex_session_#{port}"
end

Rails.application.config.session_store :cookie_store, key:, domain:
