defmodule MotmWeb.DiscordMessageLive.Show do
  use MotmWeb, :live_view

  alias Motm.Discord

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:discord_message, Discord.get_discord_message!(id))}
  end

  defp page_title(:show), do: "Show Discord message"
  defp page_title(:edit), do: "Edit Discord message"
end
