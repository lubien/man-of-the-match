defmodule MotmWeb.DiscordMessageLive.Index do
  use MotmWeb, :live_view

  alias Motm.Discord
  alias Motm.Discord.DiscordMessage

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :discord_messages, list_discord_messages())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Discord message")
    |> assign(:discord_message, Discord.get_discord_message!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Discord message")
    |> assign(:discord_message, %DiscordMessage{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Discord messages")
    |> assign(:discord_message, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    discord_message = Discord.get_discord_message!(id)
    {:ok, _} = Discord.delete_discord_message(discord_message)

    {:noreply, assign(socket, :discord_messages, list_discord_messages())}
  end

  defp list_discord_messages do
    Discord.list_discord_messages()
  end
end
