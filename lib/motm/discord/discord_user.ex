defmodule Motm.Discord.DiscordUser do
use Ecto.Schema
  import Ecto.Changeset

  schema "discord_users" do
    field :avatar, :string
    field :discord_id, :string
    field :discriminator, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(discord_user, attrs) do
    discord_user
    |> cast(attrs, [:discord_id, :username, :discriminator, :avatar])
    |> validate_required([:discord_id, :username, :discriminator, :avatar])
    |> unique_constraint(:discord_id)
  end
end
