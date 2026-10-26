# ZenToI
兆までの漢数字を半角数字に変換します。文章中に含まれる漢数字も変換できます。

[![Actions Status](https://github.com/yoshitsugu/zen_to_i/workflows/test/badge.svg)](https://github.com/yoshitsugu/zen_to_i/actions)

## Installation

Install via RubyGems.

    $ gem install zen_to_i

Or, use Bundler. Add this line to your application's Gemfile:

```ruby
gem "zen_to_i"
```

Then run:

    $ bundle

## Usage

### 1. Use the `zen_to_i` command from your shell

    $ zen_to_i "一二三"
    123

    # or use a pipe
    $ echo "一二三" | zen_to_i
    123

Please run `bundle exec zen_to_i` if you installed the gem via Bundler.

### 2. Use it in your Ruby script

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
Note that `zen_to_i` returns a String, not an Integer.

You can also override `to_i` with a refinement. The override is active only in the lexical scope where `using ZenToI::Refine` appears, and returns an Integer like the built-in `to_i` method.

```ruby
require "zen_to_i/refine"

using ZenToI::Refine

"一二三".zen_to_i
#=> "123"

"一二三".to_i
#=> 123
```

You can also replace `String#to_i` globally by requiring `zen_to_i/string_ext`. This affects all strings in the process; the original `to_i` implementation remains available as `String#_to_i`. Use this only when a global override is intended.

```ruby
require "zen_to_i/string_ext"

"一二三".zen_to_i
#=> "123"

"一二三".to_i
#=> 123
```


## Contributing

1. Fork the repository.
2. Create a feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push the branch (`git push origin my-new-feature`).
5. Create a pull request.
