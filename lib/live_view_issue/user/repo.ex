defmodule LiveViewIssue.User.Repo do
  use GenServer

  alias LiveViewIssue.User

  def start_link(init_args) do
    GenServer.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  def search(query \\ "") do
    GenServer.call(__MODULE__, {:search, query})
  end

  @impl GenServer
  def init(state) do
    {:ok, state, {:continue, :populate}}
  end

  @impl GenServer
  def handle_continue(:populate, _state) do
    users =
      for i <- 1..100 do
        %User{
          id: i,
          avatar: Faker.Avatar.image_url(),
          email: Faker.Internet.email(),
          name: Faker.Person.name()
        }
      end

    {:noreply, users}
  end

  @impl GenServer
  def handle_call({:search, ""}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:search, query}, _from, state) do
    users =
      Enum.filter(state, fn user ->
        user.name
        |> String.downcase()
        |> String.contains?(String.downcase(query))
      end)

    {:reply, {:ok, users}, state}
  end
end
