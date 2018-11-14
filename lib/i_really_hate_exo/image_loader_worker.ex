defmodule IReallyHateExo.ImageLoaderWorker do
  use GenServer

  def start_link(_) do

  end

  def init(_) do
    {:ok, nil}
  end

  def handle_cast({:request_image, url}, _, state) do
    {:noreply, state}
  end
end
