defmodule Motm.Discord do
  @moduledoc """
  The Discord context.
  """

  import Ecto.Query, warn: false
  alias Motm.Repo
  alias Phoenix.PubSub

  alias Motm.Discord.DiscordUser

  @doc """
  Returns the list of discord_users.

  ## Examples

      iex> list_discord_users()
      [%DiscordUser{}, ...]

  """
  def list_discord_users do
    Repo.all(DiscordUser)
  end

  @doc """
  Gets a single discord_user.

  Raises `Ecto.NoResultsError` if the Discord user does not exist.

  ## Examples

      iex> get_discord_user!(123)
      %DiscordUser{}

      iex> get_discord_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_discord_user!(id), do: Repo.get!(DiscordUser, id)

  @doc """
  Creates a discord_user.

  ## Examples

      iex> create_discord_user(%{field: value})
      {:ok, %DiscordUser{}}

      iex> create_discord_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_discord_user(attrs \\ %{}, opts \\ []) do
    %DiscordUser{}
    |> DiscordUser.changeset(attrs)
    |> Repo.insert(opts)
  end

  @doc """
  Updates a discord_user.

  ## Examples

      iex> update_discord_user(discord_user, %{field: new_value})
      {:ok, %DiscordUser{}}

      iex> update_discord_user(discord_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_discord_user(%DiscordUser{} = discord_user, attrs) do
    discord_user
    |> DiscordUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a discord_user.

  ## Examples

      iex> delete_discord_user(discord_user)
      {:ok, %DiscordUser{}}

      iex> delete_discord_user(discord_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_discord_user(%DiscordUser{} = discord_user) do
    Repo.delete(discord_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking discord_user changes.

  ## Examples

      iex> change_discord_user(discord_user)
      %Ecto.Changeset{data: %DiscordUser{}}

  """
  def change_discord_user(%DiscordUser{} = discord_user, attrs \\ %{}) do
    DiscordUser.changeset(discord_user, attrs)
  end

  alias Motm.Discord.DiscordMessage

  @doc """
  Returns the list of discord_messages.

  ## Examples

      iex> list_discord_messages()
      [%DiscordMessage{}, ...]

  """
  def list_discord_messages do
    DiscordMessage
    |> order_by([desc: :inserted_at])
    |> preload([:discord_user, :mentions])
    |> Repo.all()
  end

  @doc """
  Gets a single discord_message.

  Raises `Ecto.NoResultsError` if the Discord message does not exist.

  ## Examples

      iex> get_discord_message!(123)
      %DiscordMessage{}

      iex> get_discord_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_discord_message!(id), do: Repo.get!(DiscordMessage, id)

  @doc """
  Creates a discord_message.

  ## Examples

      iex> create_discord_message(%{field: value})
      {:ok, %DiscordMessage{}}

      iex> create_discord_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_discord_message(attrs \\ %{}, opts \\ []) do
    changeset = DiscordMessage.changeset(%DiscordMessage{}, attrs)

    with {:ok, message} <- Repo.insert(changeset, opts) do
      PubSub.broadcast(Motm.PubSub, "messages", {:message_created, message})
      {:ok, message}
    end
  end

  @doc """
  Updates a discord_message.

  ## Examples

      iex> update_discord_message(discord_message, %{field: new_value})
      {:ok, %DiscordMessage{}}

      iex> update_discord_message(discord_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_discord_message(%DiscordMessage{} = discord_message, attrs) do
    discord_message
    |> DiscordMessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a discord_message.

  ## Examples

      iex> delete_discord_message(discord_message)
      {:ok, %DiscordMessage{}}

      iex> delete_discord_message(discord_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_discord_message(%DiscordMessage{} = discord_message) do
    Repo.delete(discord_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking discord_message changes.

  ## Examples

      iex> change_discord_message(discord_message)
      %Ecto.Changeset{data: %DiscordMessage{}}

  """
  def change_discord_message(%DiscordMessage{} = discord_message, attrs \\ %{}) do
    DiscordMessage.changeset(discord_message, attrs)
  end

  def discord_avatar_url(%DiscordUser{discord_id: discord_id, avatar: avatar}) do
    "https://cdn.discordapp.com/avatars/#{discord_id}/#{avatar}.png"
  end

  def discord_avatar_url(nil) do
    nil
  end

  alias Motm.Discord.DiscordChannel

  @doc """
  Returns the list of discord_channels.

  ## Examples

      iex> list_discord_channels()
      [%DiscordChannel{}, ...]

  """
  def list_discord_channels do
    Repo.all(DiscordChannel)
  end

  def can_import_from_channel?(channel_id) do
    DiscordChannel
    |> where(discord_id: ^channel_id)
    |> Repo.exists?()
  end

  def enable_import_from_channel(channel_id) do
    {:ok, channel} = Nostrum.Api.get_channel(channel_id)

    create_discord_channel(%{
      name: channel.name,
      discord_id: Integer.to_string(channel.id),
      guild_id: Integer.to_string(channel.guild_id),
    },
      on_conflict: {:replace, [:name]},
      conflict_target: [:discord_id]
    )
  end

  @doc """
  Creates a discord_channel.

  ## Examples

      iex> create_discord_channel(%{field: value})
      {:ok, %DiscordChannel{}}

      iex> create_discord_channel(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_discord_channel(attrs \\ %{}, opts \\ []) do
    %DiscordChannel{}
    |> DiscordChannel.changeset(attrs)
    |> Repo.insert(opts)
  end

  @doc """
  Updates a discord_channel.

  ## Examples

      iex> update_discord_channel(discord_channel, %{field: new_value})
      {:ok, %DiscordChannel{}}

      iex> update_discord_channel(discord_channel, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_discord_channel(%DiscordChannel{} = discord_channel, attrs) do
    discord_channel
    |> DiscordChannel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a discord_channel.

  ## Examples

      iex> delete_discord_channel(discord_channel)
      {:ok, %DiscordChannel{}}

      iex> delete_discord_channel(discord_channel)
      {:error, %Ecto.Changeset{}}

  """
  def delete_discord_channel(%DiscordChannel{} = discord_channel) do
    Repo.delete(discord_channel)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking discord_channel changes.

  ## Examples

      iex> change_discord_channel(discord_channel)
      %Ecto.Changeset{data: %DiscordChannel{}}

  """
  def change_discord_channel(%DiscordChannel{} = discord_channel, attrs \\ %{}) do
    DiscordChannel.changeset(discord_channel, attrs)
  end

  def import_latest_channel_messages(guild_id, channel_id) do
    {:ok, messages} = Nostrum.Api.get_channel_messages(channel_id, 100)

    messages =
      messages
      |> Enum.map(&Map.put(&1, :guild_id, guild_id))

    Repo.transaction(fn ->
      Enum.map(messages, &import_from_discord/1)
    end)
  end

  def import_from_discord(%Nostrum.Struct.Message{content: content}) when content in [
    "!add-channel-to-man-of-the-match",
    "!import-messages-to-man-of-the-match",
    nil,
    ""
  ] do
    {:ok, :ignore}
  end

  def import_from_discord(%Nostrum.Struct.Message{} = msg) do
    with {:ok, user} <- upsert_discord_user(msg.author),
         {:ok, mentions} <- Repo.transaction(fn -> Enum.map(msg.mentions, &upsert_discord_user/1) end) do
      mentions =
        mentions
        |> Enum.map(&elem(&1, 1))

      create_discord_message(%{
        discord_user_id: user.id,
        content: msg.content,
        channel_id: Integer.to_string(msg.channel_id),
        discord_id: Integer.to_string(msg.id),
        guild_id: Integer.to_string(msg.guild_id),
        inserted_at: msg.timestamp,
        mentions: mentions
      },
        on_conflict: {:replace, [:content]},
        conflict_target: [:discord_id]
      )
    end
  end

  def upsert_discord_user(user) do
    create_discord_user(%{
      discord_id: Integer.to_string(user.id),
      username: user.username,
      discriminator: user.discriminator,
      avatar: user.avatar
    },
      on_conflict: {:replace, [:avatar]},
      conflict_target: [:discord_id]
    )
  end

  def render_message_content(discord_message) do
    discord_message.content
    |> String.split(" ")
    |> Enum.map(fn
      ("<@" <> _number) = string ->
        case Regex.run(~r/\<\@(\d+)\>/, string) do
          [_all, discord_user_id] ->
            if mentioned = Enum.find(discord_message.mentions, & &1.discord_id == discord_user_id) do
              {:mention, mentioned}
            else
              string
            end

          _ ->
            string
        end

      word ->
        word
    end)
    # |> Enum.join(" ")
  end
end
