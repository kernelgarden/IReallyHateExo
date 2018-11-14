defmodule IReallyHateExo.Store.ChartServer do
  use GenServer, restart: :temporary

  @expiration_time :timer.minutes(10)
  # TODO: DB load or store

  def start_link(timestamp_key) do
    GenServer.start_link(
      __MODULE__,
      timestamp_key,
      name: via_tuple(timestamp_key)
    )
  end

  def update(chart_pid, [] = new_song_list) do
    GenServer.cast(chart_pid, {:update_chart, new_song_list})
  end

  def update(chart_pid, updater_fun) do
    GenServer.cast(chart_pid, {:update_chart, updater_fun})
  end

  def get(chart_pid) do
    GenServer.call(chart_pid, {:get_chart})
  end

  defp via_tuple(timestamp_key) do
    IReallyHateExo.ProcessRegistry.via_tuple({__MODULE__, timestamp_key})
  end

  @impl GenServer
  def init(timestamp_key) do
    {:ok,
      IReallyHateExo.Store.Chart.new(timestamp_key, []),
      @expiration_time
    }
  end

  @impl GenServer
  def handle_cast({:update_chart, [] = new_song_list}, chart) do
    new_chart = IReallyHateExo.Store.Chart.update(chart, new_song_list)
    {:noreply, new_chart, @expiration_time}
  end

  @impl GenServer
  def handle_cast({:update_chart, updater_fun}, chart) do
    new_chart = IReallyHateExo.Store.Chart.update(chart, updater_fun)
    {:noreply, new_chart, @expiration_time}
  end

  @impl GenServer
  def handle_call({:get_chart}, _, chart) do
    {:reply, chart, chart, @expiration_time}
  end

  @impl GenServer
  def handle_info(:timeout, {list_name, todo_list}) do
    IO.puts("stopped todo server for #{list_name}")
    {:stop, :normal, {list_name, todo_list}}
  end

  @impl GenServer
  def handle_info(unknown_msg, state) do
    IO.puts("received unknown msg: #{unknown_msg}")
    {:noreply, state, @expiration_time}
  end

  def make_timestamp_key(year, month, day, hour) do
    "#{year}-#{month}-#{day}-#{hour}"
  end

  def make_timestamp_key_now() do
    date_time = DateTime.utc_now()
    make_timestamp_key(date_time.year, date_time.month, date_time.day, date_time.hour)
  end
end
