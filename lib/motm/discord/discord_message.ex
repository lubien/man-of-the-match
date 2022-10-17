defmodule Motm.Discord.DiscordMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "discord_messages" do
    field :channel_id, :string
    field :content, :string
    field :discord_id, :string
    field :guild_id, :string
    belongs_to :discord_user, Motm.Discord.DiscordUser

    timestamps()
  end

  @doc false
  def changeset(discord_message, attrs) do
    discord_message
    |> cast(attrs, [:content, :discord_id, :guild_id, :channel_id, :discord_user_id])
    |> validate_required([:content, :discord_id, :guild_id, :channel_id, :discord_user_id])
    |> unique_constraint(:discord_id)
  end
end
