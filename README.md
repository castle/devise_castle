# DeviseUserbin

Adds support to [Devise](http://github.com/plataformatec/devise) for authenticating with
Userbin.

## Installation

Install DeviseUserbin gem, it will also install dependencies (such as devise and warden):

```bash
gem install devise_userbin
```

<!--
### Automatic installation

Run the following generator to add DeviseUserbin’s configuration option in the Devise configuration file (config/initializers/devise.rb):

```bash
rails generate devise_userbin:install
```

When you are done, you are ready to add DeviseUserbin to any of your Devise models using the following generator.

```bash
rails generate devise_userbin MODEL
```

Replace MODEL by the class name you want to add DeviseUserbin, like User, Admin, etc. This will add the :userbin flag to your model's Devise modules. The generator will also create a migration file (if your ORM support them). Continue reading this file to understand exactly what the generator produces and how to use it.
-->

## Devise configuration

First run the [Devise](https://github.com/plataformatec/devise#getting-started) getting started guide.

Then replace `:database_authenticable` with `:userbin` in the `devise` call in your model. Also remove the `:lockable` module since this functionality will be handled by Userbin.

```ruby
class User < ActiveRecord::Base
  devise :userbin, :registerable # ,...
end
```

Remove all validations on email and password in your User model:

```ruby
# validates_uniqueness_of :email
# validates_format_of     :email, :with  => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/,
# ...
```

Take note of your *API secret* from your Userbin dashboard and generate a config file:

```bash
rails generate devise_userbin:install YOUR-API-SECRET
```

## Database migration

### ActiveRecord

Create a migration to add DeviseUserbin to your model:

```ruby
def change
  add_column :users, :userbin_id, :string
end
add_index :users, :userbin_id, :unique => true
```

### Mongoid

If you are using Mongoid, define the following fields and indexes within your user model:

```ruby
field :userbin_id, type: String
index( {userbin_id: 1}, {:background => true} )
```

Remember to create indexes within the MongoDB database after deploying your changes.

```bash
rake db:mongoid:create_indexes
```

## Import existing users to Userbin

If you already have an existing userbase, in order for them to login, the credentials need to be synchronized to the Userbin cloud where the passwords are re-encrypted. Once you're done with migrating your application to Userbin, you can safely remove all passwords from your local database to protect your users from breaches.

```bash
rails generate devise_userbin:import MODEL
```
