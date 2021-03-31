

# Botonera API

### Requirements

1. Ruby v2.7.2+ (ideally with [rbenv](https://github.com/rbenv/rbenv))
2. Redis
3. Postgres

### Set up
0. Have postgres and redis running on your machine
1.  Prepare database
    * Start a psql console on your machine: `psql postgres`
    * Once inside, create the following role:
      * `CREATE ROLE botonera WITH SUPERUSER LOGIN PASSWORD 'botonera';`
    * Exist the psql console, and now run the following comands in your terminal:
      * `bundle exec rake db:create`
      * `bundle exec rake db:migrate`
      * `bundle exec rake db:migrate RACK_ENV=test`
2.  Install dependencies
     * `bundle install`
3. (optional) Create a `.env` file in the root dir and replace the values below with real ones:
    * <details>
        <summary>show <strong>.env</strong> sample values</summary>
      
          AWS_ACCESS_KEY_ID      = "aws-access-key-id"
          AWS_SECRET_ACCESS_KEY  = "aws-secret-access-key"
          AWS_REGION             = "aws-region"
          GOOGLE_CLIENT_ID       = "google-client-id"
          GOOGLE_CLIENT_SECRET   = "google-client-secret"
          GOOGLE_REDIRECT_URI    = "google-redirect-url"
          FACEBOOK_CLIENT_ID     = "facebook-client-id"
          FACEBOOK_CLIENT_SECRET = "facebook-client-secret"
          FACEBOOK_REDIRECT_URI  = "facebook-redirect-uri"
          FRONT_END_URL          = "front-end-url"
        
      </details>

### Run the app
* server: `bin/server`
* console: `bin/console`

### Test the app
* unit tests: `bundle exec rspec`
* linter: `bundle exec rubocop`