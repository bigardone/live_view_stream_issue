defmodule LiveViewIssueWeb.PageLive do
  use LiveViewIssueWeb, :live_view

  alias LiveViewIssue.{User, User.Repo}

  @impl Phoenix.LiveView
  def handle_params(params, _uri, socket) do
    query = Map.get(params, "q", "")

    {:ok, users} = Repo.search(query)

    socket =
      socket
      |> assign(:users_count, length(users))
      |> assign(:form, to_form(params))
      |> stream(:users, users, reset: true)

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <section class="space-y-4">
      <.link navigate={~p"/issue"} class="underline">Go to issue page</.link>

      <h1 class="text-2xl font-bold">Main</h1>

      <.simple_form for={@form} as="search" phx-change="search">
        <.focus_wrap id="search_form">
          <.input field={@form[:q]} phx-debounce="300" />
        </.focus_wrap>
      </.simple_form>

      <div><%= @users_count %></div>
      <div class="grid grid-cols-3 gap-6 auto-rows-auto mb-6" id="users_list" phx-update="stream">
        <.user :for={{id, user} <- @streams.users} id={id} user={user} />
      </div>
    </section>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("search", %{"q" => query}, socket) do
    {:noreply, push_patch(socket, to: ~p"/?#{[q: query]}")}
  end

  attr(:id, :string, required: true)
  attr(:user, User, required: true)

  defp user(assigns) do
    ~H"""
    <div id={@id} class="gap-y-4 rounded-md flex flex-col items-center justify-center p-6 bg-white">
      <img class="h-16 rounded-full" src={@user.avatar} />

      <div><%= @user.id %></div>
      <div><%= @user.name %></div>
      <div><%= @user.email %></div>
    </div>
    """
  end
end
