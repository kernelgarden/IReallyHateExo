defmodule IReallyHateExo.Store.SongInfo do
  defstruct rank: 0, title: "title", artist: "artist", img_url: "img_url"

  def new(), do: %IReallyHateExo.Store.SongInfo{}
end
