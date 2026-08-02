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

# The SAML ACS is a cross-site POST from the IdP, and a SameSite=Lax cookie isn't sent on
# one — so the callback sees no session at all. Left unset everywhere by default; this only
# exists so the SSO test environment can relax it while the real fix is decided.
same_site = ENV["SESSION_COOKIE_SAME_SITE"].presence&.to_sym

options = {key:, domain:}
options[:same_site] = same_site if same_site
Rails.application.config.session_store :cookie_store, **options
