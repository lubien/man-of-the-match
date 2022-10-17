defmodule Motm.Repo.Migrations.CreateDiscordUsers do
  use Ecto.Migration

  def change do
    create table(:discord_users) do
      add :discord_id, :string
      add :username, :string
      add :discriminator, :string
      add :avatar, :string

      timestamps()
    end

    create unique_index(:discord_users, [:discord_id])
  end
end
