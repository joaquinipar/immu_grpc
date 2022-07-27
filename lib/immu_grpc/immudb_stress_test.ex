defmodule ImmuGrpc.ImmudbStressTest do
  @doc """
  These async functions will only work when we raise the limit of spawned erlang processes.
  $ ELIXIR_ERL_OPTIONS="+P 500000" iex -S mix
  """


  def fill_million_records() do
    Enum.each(0..1_000_000, fn(x) -> x |> Integer.to_string() |> ImmuGrpc.ImmudbHandler.set("stress_test") end)

    :ok
  end

  def fill_million_records_async() do
    0..1_000_000
    |> Enum.map(&Task.async(fn -> set_number(&1) end))
    |> Enum.map(&Task.await(&1))

    :ok
  end

  def fill_hundred_million_records_async() do
    0..100_000_000
    |> Enum.map(&Task.async(fn -> set_number(&1) end))
    |> Enum.map(&Task.await(&1))

    :ok
  end

  defp set_number(x) when is_number(x) do
    x
    |> Integer.to_string()
    |> ImmuGrpc.ImmudbHandler.set("stress_test")
  end

end
