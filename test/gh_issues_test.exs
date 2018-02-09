defmodule GhIssuesTest do
  use ExUnit.Case
  doctest GhIssues

  import GhIssues.Cli, only: [ parse_args: 1 ]

  test "引数が-hか--helpのときは:helpが返ること" do
    assert parse_args([ "-h", "anything" ]) == :help
    assert parse_args([ "--help", "anything" ]) == :help
  end

  test "引数が3つあったら、その3つが返ること" do
    assert(parse_args([ "user", "project", "99" ]) == { "user", "project", 99 })
  end

  test "引数が2つだったら、最後に@default_countが追加されて返ること" do
    assert(parse_args([ "user", "project" ]) == { "user", "project", 4 })
  end
end
