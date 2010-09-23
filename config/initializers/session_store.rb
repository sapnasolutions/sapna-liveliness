# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_sapna-liveliness_session',
  :secret      => '4942a2ebc5b389628418a4c8e95b1354fe89b80fca863fc4bc5e9535e054169e9c7e61b010691b21a72db63cc5045eb48eafe1ddd9e47c7e201e63ec427af7d9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
