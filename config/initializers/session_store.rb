# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_planetacordobapedia_session',
  :secret      => 'c8d63200f4377a33a312ed25156fd2efa72d34297cab7d0a79827f3f8933a3ddda530a7ff8a2705b4d2d99f2593011953f4f43a071ba600c038a952298395994'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
