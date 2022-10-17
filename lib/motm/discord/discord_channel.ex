defmodule Motm.Discord.DiscordChannel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "discord_channels" do
    field :discord_id, :string
    field :guild_id, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(discord_channel, attrs) do
    discord_channel
    |> cast(attrs, [:discord_id, :guild_id, :name])
    |> validate_required([:discord_id, :guild_id, :name])
    |> unique_constraint(:discord_id)
  end
end
