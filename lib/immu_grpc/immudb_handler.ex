defmodule ImmuGrpc.ImmudbHandler do

  use GenServer
  @name :immudb_genserver

  defmodule State do
    defstruct socket: %Immudb.Socket{}
  end

  # Client Interface

  def start_link(_arg) do
    IO.puts("Starting ImmuDB state process..")
    GenServer.start_link(__MODULE__, %State{}, name: @name)
  end

    # Key Value

  def set(key, value) do
    GenServer.call(@name, {:set_key_value, key, value})
  end

  def verifiable_set(key, value) do
    GenServer.call(@name, {:verifiable_set_key_value, key, value})
  end

  def get(key) do
    GenServer.call(@name, {:get_value, key})
  end

  def verifiable_get(key) do
    GenServer.call(@name, {:verifiable_get_value, key})
  end

  def history(key) do
    GenServer.call(@name, {:history, key})
  end

  # Server Callbacks

  @impl true
  def init(state) do
    {:ok, socket} = Immudb.new(
    host: "127.0.0.1",
    port: 3322,
    username: "immudb",
    password: "immudb",
    database: "defaultdb"
    )

    IO.inspect(socket)

    {:ok, %{state | socket: socket}}
  end

  @impl true
  def handle_call({:set_key_value, key, value}, _from, state) do

    Immudb.set(state.socket, key, value)

    {:reply, :ok, state}
  end

  def handle_call({:verifiable_set_key_value, key, value}, _from, state) do

    Immudb.verifiable_set(state.socket, key, value)

    {:reply, :ok, state}
  end

  def handle_call({:get_value, key}, _from, state) do

    value = Immudb.get(state.socket, key)

    {:reply, value, state}
  end

  def handle_call({:verifiable_get_value, key}, _from, state) do

    value = Immudb.verifiable_get(state.socket, key)

    {:reply, value, state}
  end

  def handle_call({:history, key}, _from, state) do

    value = Immudb.history(state.socket, key)

    {:reply, value, state}
  end
end
