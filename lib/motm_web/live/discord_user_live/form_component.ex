defmodule MotmWeb.DiscordUserLive.FormComponent do
  use MotmWeb, :live_component

  alias Motm.Discord

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage discord_user records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="discord_user-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :discord_id}} type="text" label="discord_id" />
        <.input field={{f, :username}} type="text" label="username" />
        <.input field={{f, :discriminator}} type="text" label="discriminator" />
        <.input field={{f, :avatar}} type="text" label="avatar" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Discord user</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{discord_user: discord_user} = assigns, socket) do
    changeset = Discord.change_discord_user(discord_user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"discord_user" => discord_user_params}, socket) do
    changeset =
      socket.assigns.discord_user
      |> Discord.change_discord_user(discord_user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"discord_user" => discord_user_params}, socket) do
    save_discord_user(socket, socket.assigns.action, discord_user_params)
  end

  defp save_discord_user(socket, :edit, discord_user_params) do
    case Discord.update_discord_user(socket.assigns.discord_user, discord_user_params) do
      {:ok, _discord_user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Discord user updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_discord_user(socket, :new, discord_user_params) do
    case Discord.create_discord_user(discord_user_params) do
      {:ok, _discord_user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Discord user created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
