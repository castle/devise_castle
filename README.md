# DEPRECATED: please use [Castle middleware](https://github.com/castle/castle-ruby-middleware#devise) instead


[![Gem Version](https://badge.fury.io/rb/devise_castle.png)](http://badge.fury.io/rb/devise_castle)
[![Dependency Status](https://gemnasium.com/castle/devise_castle.png)](https://gemnasium.com/castle/devise_castle)

# DeviseCastle

Adds support to [Devise](http://github.com/plataformatec/devise) for protecting your user accounts with [Castle](https://castle.io). Castle monitors your login system and stops account hijacks in real-time.

## Installation

Before you start, make sure that you've set up [Devise](https://github.com/plataformatec/devise#getting-started) in your Rails application.

1. First add the `devise_castle` gem to your Gemfile:

  ```ruby
  gem 'devise_castle'
  ```

1. Install the gem:

  ```bash
  bundle install
  ```

1. Take note of your *API secret* from your Castle dashboard and run the installation generator. This will add Castle configuration to your devise.rb initializer and add a devise_castle.en.yml to your locale files.

  ```bash
  rails generate devise_castle:install YOUR-API-SECRET
  ```

1. When you are done, you are ready to add DeviseCastle to any of your Devise models using the following generator. Replace MODEL by the class name you want to add DeviseCastle, like `User`, `Admin`, etc.

  ```bash
  rails generate devise_castle MODEL
  ```

1. That's it! Now log in to your application and watch your user appear in the [Castle dashboard](https://dashboard.castle.io).

## Supported events

These events are automatically tracked by the extension:

- `$login.succeeded`
- `$login.failed`
- `$logout.succeeded`
- `$registration.succeeded`
- `$registration.failed`
- `$password_change.succeeded`
- `$password_change.failed`
- `$password_reset.requested`
- `$password_reset.succeeded`
- `$password_reset.failed`

These events need to be tracked *manually*:

- `$challenge.requested`
- `$challenge.succeeded`
- `$challenge.failed`
- `$email_change.requested`
- `$email_change.succeeded`
- `$email_change.failed`

## Configuration

### Handling errors

By default, all Castle exceptions are handled silently. Uncomment these lines in `config/initializers/devise.rb` to create a custom error handler:

```ruby
  # config.castle_error_handler = Proc.new { |exception|
  #   # Handle error from Castle
  # }
```

### Models

By default, the `id` field of your user model will be used as the identifer when creating and querying Castle users. If you have multiple user models that risk generating the same identifier, you can override `castle_id` in your models:

```ruby
class Admin < User
  def castle_id
    "admin-#{id}"
  end
end
```

