# ZenToI

## Installation

Add this line to your application's Gemfile:

    gem 'zen_to_i'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zen_to_i

## Usage

```ruby
  "hoge".zen_to_i
  #=> "hoge"

  "一二三".zen_to_i
  #=> "123"

  "百三".zen_to_i
  #=> "103"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
