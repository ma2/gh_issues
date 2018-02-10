defmodule GhIssuesTest do
  use ExUnit.Case
  doctest GhIssues

  import GhIssues.Cli, only: [ parse_args: 1, sort_into_ascending_order: 1, convert_to_list_of_maps: 1 ]

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

  test "マップのリストをcreated_at昇順に並び替えること" do
    result = sort_into_ascending_order(fake_created_at_list([ "c", "a", "b" ]))
    issues = for issue <- result, do: issue[ "created_at" ]
    assert issues == ~w{a b c}
  end

  defp fake_created_at_list(values) do
    data = for value <- values, do: [ { "created_at", value }, { "other_data", "xxx" } ]
    convert_to_list_of_maps(data)
  end
end
