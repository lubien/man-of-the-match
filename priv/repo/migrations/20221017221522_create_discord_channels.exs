defmodule Motm.Repo.Migrations.CreateDiscordChannels do
  use Ecto.Migration

  def change do
    create table(:discord_channels) do
      add :discord_id, :string
      add :guild_id, :string
      add :name, :string

      timestamps()
    end

    create unique_index(:discord_channels, [:discord_id])
  end
end
