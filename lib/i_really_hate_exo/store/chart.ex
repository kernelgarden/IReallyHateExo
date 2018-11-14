defmodule IReallyHateExo.Store.Chart do
  defstruct timestamp_key: "2018-9-10-13", song_infos: []

  alias __MODULE__

  def new(timestamp_key, song_infos \\ []) when is_list(song_infos) do
    %Chart{timestamp_key: timestamp_key, song_infos: song_infos}
  end

  def update(chart, new_song_infos) when is_list(new_song_infos) do
    %Chart{chart | song_infos: new_song_infos}
  end

  def update(chart, updater_fun) do
    update(chart, updater_fun.(chart))
  end
end
