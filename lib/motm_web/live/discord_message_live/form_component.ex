defmodule MotmWeb.DiscordMessageLive.FormComponent do
  use MotmWeb, :live_component

  alias Motm.Discord

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage discord_message records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="discord_message-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :content}} type="text" label="content" />
        <.input field={{f, :discord_id}} type="text" label="discord_id" />
        <.input field={{f, :guild_id}} type="text" label="guild_id" />
        <.input field={{f, :channel_id}} type="text" label="channel_id" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Discord message</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{discord_message: discord_message} = assigns, socket) do
    changeset = Discord.change_discord_message(discord_message)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"discord_message" => discord_message_params}, socket) do
    changeset =
      socket.assigns.discord_message
      |> Discord.change_discord_message(discord_message_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"discord_message" => discord_message_params}, socket) do
    save_discord_message(socket, socket.assigns.action, discord_message_params)
  end

  defp save_discord_message(socket, :edit, discord_message_params) do
    case Discord.update_discord_message(socket.assigns.discord_message, discord_message_params) do
      {:ok, _discord_message} ->
        {:noreply,
         socket
         |> put_flash(:info, "Discord message updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_discord_message(socket, :new, discord_message_params) do
    case Discord.create_discord_message(discord_message_params) do
      {:ok, _discord_message} ->
        {:noreply,
         socket
         |> put_flash(:info, "Discord message created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
