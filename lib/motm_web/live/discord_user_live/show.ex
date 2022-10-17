defmodule MotmWeb.DiscordUserLive.Show do
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
     |> assign(:discord_user, Discord.get_discord_user!(id))}
  end

  defp page_title(:show), do: "Show Discord user"
  defp page_title(:edit), do: "Edit Discord user"
end
