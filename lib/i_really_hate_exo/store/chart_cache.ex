defmodule IReallyHateExo.Store.ChartCache do

  def start_link() do
    IO.puts("Starting Chart Cache")

    DynamicSupervisor.start_link(
      name: __MODULE__,
      strategy: :one_for_one
    )
  end

  def chart_process(year, month, day, hour) do
    chart_process(IReallyHateExo.Store.ChartServer.make_timestamp_key(
      year, month, day, hour
    ))
  end

  def chart_process(timestamp_key) do
    case start_child(timestamp_key) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  defp start_child(timestamp_key) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {IReallyHateExo.Store.ChartServer, timestamp_key}
    )
  end
end
