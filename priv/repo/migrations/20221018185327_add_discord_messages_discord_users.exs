defmodule Motm.Repo.Migrations.AddDiscordMessagesDiscordUsers do
  use Ecto.Migration

  def change do
    create table(:discord_messages_discord_users, primary_key: false) do
      add :discord_message_id, references(:discord_messages)
      add :discord_user_id, references(:discord_users)
    end
  end
end
