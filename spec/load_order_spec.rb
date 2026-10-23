# frozen_string_literal: true

require "open3"
require "rbconfig"

RSpec.describe "ロード順" do
  # refinement の定義は読み込み時点のグローバル String#to_i に影響されるため、
  # ロード順によって挙動が変わらないことをサブプロセスで検証する。
  def run_script(script)
    stdout, stderr, status = Open3.capture3(
      RbConfig.ruby, "-I", File.expand_path("../lib", __dir__), "-e", script
    )
    raise "script failed: #{stderr}" unless status.success?

    stdout.strip
  end

  it "string_ext の後に refine を読み込んでも to_i が変換結果を返す" do
    output = run_script(<<~RUBY)
      require "zen_to_i/string_ext"
      require "zen_to_i/refine"
      using ZenToI::Refine
      print "一二三".to_i
    RUBY

    expect(output).to eq "123"
  end

  it "refine の後に string_ext を読み込んでも to_i が変換結果を返す" do
    output = run_script(<<~RUBY)
      require "zen_to_i/refine"
      require "zen_to_i/string_ext"
      using ZenToI::Refine
      print "一二三".to_i
    RUBY

    expect(output).to eq "123"
  end

  it "ロード順によらず _to_i は素の to_i と同じ結果を返す" do
    outputs = [
      <<~RUBY,
        require "zen_to_i/string_ext"
        require "zen_to_i/refine"
        using ZenToI::Refine
        print "一二三"._to_i
      RUBY
      <<~RUBY
        require "zen_to_i/refine"
        require "zen_to_i/string_ext"
        using ZenToI::Refine
        print "一二三"._to_i
      RUBY
    ].map { |script| run_script(script) }

    expect(outputs).to eq %w[0 0]
  end

  it "先に定義された String#_to_i を上書きしない" do
    output = run_script(<<~RUBY)
      class String
        def _to_i(*)
          "third-party"
        end
      end
      require "zen_to_i/string_ext"
      print "一二三"._to_i, " ", "一二三".to_i
    RUBY

    expect(output).to eq "third-party 123"
  end
end
