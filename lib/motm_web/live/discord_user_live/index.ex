defmodule MotmWeb.DiscordUserLive.Index do
  use MotmWeb, :live_view

  alias Motm.Discord
  alias Motm.Discord.DiscordUser

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :discord_users, list_discord_users())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Discord user")
    |> assign(:discord_user, Discord.get_discord_user!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Discord user")
    |> assign(:discord_user, %DiscordUser{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Discord users")
    |> assign(:discord_user, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    discord_user = Discord.get_discord_user!(id)
    {:ok, _} = Discord.delete_discord_user(discord_user)

    {:noreply, assign(socket, :discord_users, list_discord_users())}
  end

  defp list_discord_users do
    Discord.list_discord_users()
  end
end
