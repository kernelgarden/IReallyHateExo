defmodule IReallyHateExo.ScatterWorker do
  use Task

  alias IReallyHateExo.Store.ChartCache
  alias IReallyHateExo.Store.ChartServer

  @time_zone "Asia/Seoul"

  @melon_chart_link "https://www.melon.com/chart/index.htm"

  def start_link(_args), do: Task.start_link(&loop/0)

  def loop() do
    song_list = parse_chart()
    chart = ChartCache.chart_process(
      ChartServer.make_timestamp_key_now()
    )
    ChartServer.update(chart, song_list)

    Process.sleep(get_remain_time())
    loop()
  end

  def parse_chart() do
    %HTTPoison.Response{body: tree} = HTTPoison.get!(@melon_chart_link)
    chart_list = Enum.concat(Floki.find(tree, ".lst50"), Floki.find(tree, ".lst100"))

    Enum.map(chart_list, &parse_chart_info(&1))
  end

  defp parse_chart_info(raw_info) do
    rank =
      Floki.find(raw_info, ".rank")
      |> Floki.text

    img_url =
      Floki.find(raw_info, ".wrap img")
      |> Floki.attribute("src")
      |> Floki.text

    title =
      Floki.find(raw_info, ".rank01 a")
      |> Floki.text

    artist =
      Floki.find(raw_info, ".rank02 a")
      |> Floki.text

    %IReallyHateExo.Store.SongInfo{rank: rank, title: title, artist: artist, img_url: img_url}
  end

  defp get_remain_time() do
    now_date_time = Timex.now(@time_zone)
    left_min = 60 - now_date_time.minute
    :timer.minutes(left_min)
  end
end
