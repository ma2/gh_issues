defmodule GhIssues.Cli do
  @default_count 4  # イコールを使わないことに注意

  @moduledoc """
  コマンドラインを解析する
  指定されたGitHubプロジェクトのissueの最新の _n_ 個を表形式で表示する
  """
  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  def process(:help) do
    IO.puts """
      usage: gh_issues <user> <project> [count | #{@default_count}]
    """
    System.halt(0)
  end

  def process({ user, project, count }) do
    GhIssues.Issues.fetch(user, project)
    |> decode_response
    |> convert_to_list_of_maps
    |> sort_into_ascending_order
    |> Enum.take(count)
  end

  @doc """
  `argv` が-hか--helpだった場合には:helpを返す
  そうでなければGitHubのユーザ名、プロジェクト名、issueの取得個数（オプション）である
  `{ user, project, count }`タプルを返す
  """
  def parse_args(argv) do
    parse = OptionParser.parse(
      argv,
      switches: [
        help: :boolean
      ],
      aliases: [
        h: :help
      ]
    )

    case parse do
      { [ help: true ], _, _ } -> :help
      { _, [ user, project, count ], _ } -> { user, project, String.to_integer(count) }
      { _, [ user, project ], _ } -> { user, project, @default_count }
      _ -> :help
    end
  end

  def decode_response({ :ok, body }), do: body

  def decode_response({ :error, error }) do
    { _, message } = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end

  def convert_to_list_of_maps(list) do
    list
    |> Enum.map(&Enum.into(&1, Map.new))
  end

  def sort_into_ascending_order(list_of_issues) do
    Enum.sort list_of_issues, fn i1, i2 -> i1[ "created_at" ] <= i2[ "created_at" ] end
  end

end
