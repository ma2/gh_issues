defmodule GhIssues.TableFormatter do
  require Logger
  import Enum, only: [ each: 2, map: 2, map_join: 3, max: 1 ]

  @doc """
  rowsは行データで、マップのリスト
  headersはヘッダ名のリスト
  ヘッダで指定された各行のカラムの値を表形式でSTDOUTに出力する
  カラム名は先頭行から取得する
  カラムの幅は、最も長い値が収まるように計算する
  """
  def print_table_for_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers),
         column_width = widths_of(data_by_columns),
         format = format_for(column_width)
      do
      puts_one_line_in_columns(headers, format)
      IO.puts(separator(column_width))
      puts_in_columns(data_by_columns, format)
    end
  end

  @doc """
  rowsは行のリストで、各行はカラムをキーにしたリスト
  `headers`は抜き出すカラム名のリスト
  各カラムのデータを含んだリストのリストを返す

  ## 例
  iex(1)> [Enum.into([{"a", "1"},{"b", "2"},{"c", "3"}], %{}),
  ...(1)> Enum.into([{"a", "4"},{"b", "5"},{"c", "6"}], %{})]
  [%{"a" => "1", "b" => "2", "c" => "3"}, %{"a" => "4", "b" => "5", "c" => "6"}]

  """
  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[ header ])
    end
  end

  @doc """
  strを印刷可能な文字に変換する
  """
  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  @doc """
  columnsはサブリストのリスト。サブリストはカラムのデータを含む
  各カラムごとにデータの最大長のリストを返す

  ## 例
  iex(2)> data = [ [ "cat", "wombat", "elk"], ["mongoose", "ant", "gnu"]]
  iex(3)> GhIssues.TableFormatter.widths_of(data)
  [6, 8]
  """
  def widths_of(columns) do
    for column <- columns, do: column |> map(&String.length/1) |> max
  end

  @doc """
  カラムの幅のリストからフォーマット文字列を返す
  カラム間は`" | "`で区切る

  ## 例
  iex(4)> widths = [5,6,99]
  iex(5)> GhIssues.TableFormatter.format_for(widths)
  "~-5s | ~-6s | ~-99s~n"
  """
  def format_for(column_widths) do
    map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  @doc """
  ヘッダ行の次に出力するラインを作る
  ハイフン（-）がカラムの幅だけあり、カムラの間にはプラス（+）がある

  ## 例
  iex(6)> widths = [5,6,9]
  iex(7)> GhIssues.TableFormatter.separator(widths)
  "------+--------+----------"
  """
  def separator(column_widths) do
    map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  @doc """
  data_by_columns: 列ごとのデータのリスト
  format : フォーマット文字列
  行ごとのデータのリストとフォーマット文字列に変換して、各行ごとにputs_one_line_in_columnsを呼び出す
  """
  def puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip
    |> map(&Tuple.to_list/1)
    |> each(&puts_one_line_in_columns(&1, format))
  end

  def puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end
end