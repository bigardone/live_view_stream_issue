defmodule LiveViewIssueWeb.IssuePageLive do
  use LiveViewIssueWeb, :live_view

  alias __MODULE__.UserComponent
  alias LiveViewIssue.User.Repo

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
      <.link navigate={~p"/"} class="underline">Go to main page</.link>

      <h1 class="text-2xl font-bold">Issue</h1>

      <p>Use the search input to see the rendering issues</p>

      <.simple_form for={@form} as="search" phx-change="search">
        <.focus_wrap id="search_form">
          <.input field={@form[:q]} phx-debounce="300" />
        </.focus_wrap>
      </.simple_form>

      <div><%= @users_count %></div>
      <div class="grid grid-cols-3 gap-6 auto-rows-auto mb-6" id="users_list" phx-update="stream">
        <.live_component
          :for={{id, user} <- @streams.users}
          module={UserComponent}
          id={id}
          user={user}
        />
      </div>
    </section>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("search", %{"q" => query}, socket) do
    {:noreply, push_patch(socket, to: ~p"/issue?#{[q: query]}")}
  end
end
