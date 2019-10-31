# ZenToI
兆までの漢数字を半角数字に変換します。
漢数字が続いていたらそれぞれ変換します。

[![Actions Status](https://github.com/yoshitsugu/zen_to_i/workflows/test/badge.svg)](https://github.com/yoshitsugu/zen_to_i/actions)

## Installation

install via rubygems

    $ gem install zen_to_i

Or, you can use bundler. Please add this line to your application's Gemfile:

```ruby:Gemfile
gem 'zen_to_i'
```

And then execute:

    $ bundle

## Usage

## 1. You can use `zen_to_i` command from your shell

    $ zen_to_i "一二三"
    123

    # or you can use with pipe
    $ echo "一二三" | zen_to_i
    123

Please call `bundle exec zen_to_i` if you install this gem via bundler.

### 2. In your Ruby script

```ruby
require 'zen_to_i'

"hoge".zen_to_i
#=> "hoge"

"一二三".zen_to_i
#=> "123"

"百三".zen_to_i
#=> "103"

"三兆五十二万四十八".zen_to_i
#=> "3000000520048"
```
Note that `zen_to_i` returns String, not Integer.  
  
Or you can overwrite `to_i` method with Refinements.  
This returns Integer same as default `to_i` method.

```ruby
require "zen_to_i/refine"

using ZenToI::Refine

"一二三".zen_to_i
#=> "103"

"一二三".to_i
#=> 103
```

Also, you can implicitly overwrite `to_i` method by `require "zen_to_i/string_ext"`.  
Of course it is very dangerous. Please be careful to use it.

```ruby
require "zen_to_i/string_ext"

"一二三".zen_to_i
#=> "103"

"一二三".to_i
#=> 103
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
