# frozen_string_literal: true

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
  spec.homepage      = "https://github.com/yoshitsugu/zen_to_i"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.4.0"

  spec.metadata = { "rubygems_mfa_required" => "true" }

  spec.files = `git ls-files -z`.split("\x0").grep(%r{\A(?:lib/|bin/|LICENSE\.txt\z|README\.md\z)})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
