defmodule Motm.Repo.Migrations.CreateDiscordMessages do
  use Ecto.Migration

  def change do
    create table(:discord_messages) do
      add :content, :string
      add :discord_id, :string
      add :guild_id, :string
      add :channel_id, :string
      add :discord_user_id, references(:discord_users, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:discord_messages, [:discord_id])
    create index(:discord_messages, [:discord_user_id])
  end
end
