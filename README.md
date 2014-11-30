# Isuggest

[![Gem Version](https://badge.fury.io/rb/isuggest.svg)](http://badge.fury.io/rb/isuggest)

This gem generates a list of suggested name/ email if there already exists a value in the DB. This 
could be user in signup pages when new user creates an account if the email/username is not unique we provide suggesstions

[![Gem Version](https://badge.fury.io/rb/isuggest.svg)](http://badge.fury.io/rb/isuggest)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'isuggest'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install isuggest

## Usage

In the model just add the below line 
```ruby
  suggest_me :on => ['name']
```

Options available
 ```ruby
   suggest_me :on => ['name'], :seperator => '_', :total_suggestions => 5
```




Example
```
class User
    suggest_me :on => ['name']
end

new_user = User.new('NewUser')

new_user.suggestions # returns arrays of result like ['NewUser1', 'NewUser_2', 'NewUser12', NewUser_1]
```

TODO: 
1. Allow users to specify multiple columns in the "on" option

## Contributing

1. Fork it ( https://github.com/roshandevadiga/mycodes/isuggest/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request