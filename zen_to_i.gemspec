lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "zen_to_i/version"

Gem::Specification.new do |spec|
  spec.name          = "zen_to_i"
  spec.version       = ZenToI::VERSION
  spec.authors       = ["yoshitsugu"]
  spec.email         = ["zeroinon1206bass@gmail.com"]
  spec.description   = "全角文字に含まれる数字を半角の数値に変換。兆まで対応"
  spec.summary       = "Japanese zenkaku to number"
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.6"

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) {|f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "onkcop"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
