# DeviseUserbin

Adds support to [Devise](http://github.com/plataformatec/devise) for authenticating with
Userbin.

## Installation

If your working with a fresh project, first run the [Devise](https://github.com/plataformatec/devise#getting-started) getting started guide to set up the authentication.

Then install the DeviseUserbin gem:

```bash
gem install devise_userbin
```

Take note of your *API secret* from your Userbin dashboard and run the installation generator. This will add Userbin configuration to your devise.rb initializer and add a devise_userbin.en.yml to your locale files.

```bash
rails generate devise_userbin:install YOUR-API-SECRET
```

When you are done, you are ready to add DeviseUserbin to any of your Devise models using the following generator. Replace MODEL by the class name you want to add DeviseUserbin, like User, Admin, etc.

```bash
rails generate devise_userbin MODEL
```

If you're using ActiveRecord, the generator will also create a migration file, so you'll need to run:

```bash
rake db:migrate
```

## Configuration

### Configuring views

All the views are packaged inside the gem. If you'd like to customize the views, invoke the following generator and it will copy all the views to your application:

```bash
rails generate devise_userbin:views
```

You can also use the generator to generate scoped views:

```bash
rails generate devise_userbin:views users
```

Then turn on scoped views in config/initializers/devise.rb:

```bash
config.scoped_views = true
```

## Importing existing users to Userbin

To get started faster with Userbin, do an initial import of all your users:

```bash
rails generate devise_userbin:import MODEL
```
