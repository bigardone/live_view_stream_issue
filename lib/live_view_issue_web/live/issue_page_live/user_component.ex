defmodule LiveViewIssueWeb.IssuePageLive.UserComponent do
  use LiveViewIssueWeb, :live_component

  @impl Phoenix.LiveComponent
  def render(assigns) do
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
