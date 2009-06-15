# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_gui_session',
  :secret      => 'b67b2d00ea99a0912cabded9dd134fae233c871c5bd29a0ee59328948eebd2a227363d86191a04e2233f8197fbb0881c5a35e3ada17153f08641565546efb3bd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
