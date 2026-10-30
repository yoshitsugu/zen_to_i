# ZenToI
兆までの漢数字を半角数字に変換します。文章中に含まれる漢数字も変換できます。

[![Actions Status](https://github.com/yoshitsugu/zen_to_i/workflows/test/badge.svg)](https://github.com/yoshitsugu/zen_to_i/actions)

## インストール

RubyGems からインストールします。

    $ gem install zen_to_i

または Bundler を使います。アプリケーションの Gemfile に次の行を追加してください。

```ruby
gem "zen_to_i"
```

その後、次を実行します。

    $ bundle

## 使い方

### 1. シェルから `zen_to_i` コマンドを使う

    $ zen_to_i "一二三"
    123

    # パイプで渡すこともできます
    $ echo "一二三" | zen_to_i
    123

Bundler経由で gem をインストールした場合は `bundle exec zen_to_i` を実行してください。

### 2. Ruby スクリプト内で使う

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
`zen_to_i` は Integer ではなく String を返すことに注意してください。

refinement で `to_i` を上書きすることもできます。上書きは `using ZenToI::Refine` が書かれた語彙スコープ内だけで有効で、組み込みの `to_i` メソッドと同様に Integer を返します。

```ruby
require "zen_to_i/refine"

using ZenToI::Refine

"一二三".zen_to_i
#=> "123"

"一二三".to_i
#=> 123
```

`zen_to_i/string_ext` を require すると `String#to_i` をプロセス全体で置き換えることもできます。これはプロセス内のすべての文字列に影響します。元の `to_i` の実装は `String#_to_i` として残ります。グローバルな上書きが意図している場合にのみ使ってください。

```ruby
require "zen_to_i/string_ext"

"一二三".zen_to_i
#=> "123"

"一二三".to_i
#=> 123
```

基数を指定した `to_i` も使えます。基数は漢数字を変換した後の文字列に適用されるため、漢数字と基数を組み合わせると直感と異なる値になります。

```ruby
"十六".to_i(16)
#=> 22   # 十六 は 16 ではない

"一〇".to_i(2)
#=> 2
```


## Contributing

1. Fork the repository.
2. Create a feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push the branch (`git push origin my-new-feature`).
5. Create a pull request.
