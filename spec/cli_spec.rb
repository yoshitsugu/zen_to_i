# frozen_string_literal: true

require "open3"
require "pty"
require "rbconfig"

RSpec.describe "zen_to_i command" do
  let(:lib_dir) { File.expand_path("../lib", __dir__) }
  let(:bin) { File.expand_path("../bin/zen_to_i", __dir__) }

  def run_with_tty(*)
    output = +""
    status = nil
    PTY.spawn(RbConfig.ruby, "-I#{lib_dir}", bin, *) do |reader, writer, pid|
      writer.close
      output = read_output(reader)
      _, status = Process.wait2(pid)
    end
    [output.gsub("\r\n", "\n"), status.exitstatus]
  end

  def read_output(reader)
    output = +""
    begin
      loop { output << reader.readpartial(1024) }
    rescue EOFError, Errno::EIO
      nil
    end
    output
  end

  def run_with_pipe(input)
    out, _err, status = Open3.capture3(RbConfig.ruby, "-I#{lib_dir}", bin, stdin_data: input)
    [out, status.exitstatus]
  end

  it "引数を渡すと変換結果を出力する" do
    output, exitstatus = run_with_tty("一二三")
    expect(output).to eq "123\n"
    expect(exitstatus).to eq 0
  end

  it "引数を渡すと単位単体も変換する" do
    output, exitstatus = run_with_tty("万")
    expect(output).to eq "10000\n"
    expect(exitstatus).to eq 0
  end

  it "引数がないときは Usage を出力して終了する" do
    output, exitstatus = run_with_tty
    expect(output).to include "Usage: zen_to_i (string)"
    expect(exitstatus).to eq 1
  end

  it "引数が2つ以上のときは Usage を出力して終了する" do
    output, exitstatus = run_with_tty("一二三", "四五六")
    expect(output).to include "Usage: zen_to_i (string)"
    expect(exitstatus).to eq 1
  end

  it "パイプで渡された行を1行ずつ変換する" do
    out, exitstatus = run_with_pipe("一二三\n四五六\n")
    expect(out).to eq "123\n456\n"
    expect(exitstatus).to eq 0
  end

  it "読み取りに失敗したら終了コード2で終了する" do
    reader, writer = IO.pipe
    pid = Process.spawn(RbConfig.ruby, "-I#{lib_dir}", bin, in: "/", out: File::NULL, err: writer)
    writer.close
    err = reader.read
    _, status = Process.wait2(pid)
    expect(err).to include "Errno::EISDIR"
    expect(status.exitstatus).to eq 2
  end
end
