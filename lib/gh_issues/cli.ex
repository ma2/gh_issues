defmodule GhIssues.Cli do
  @default_count 4  # イコールを使わないことに注意

  @moduledoc """
  コマンドラインを解析する
  指定されたGitHubプロジェクトのissueの最新の _n_ 個を表形式で表示する
  """
  def run(argv) do
    parse_args(argv)
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
end
