defmodule Motm.DiscordFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Motm.Discord` context.
  """

  @doc """
  Generate a unique discord_user discord_id.
  """
  def unique_discord_user_discord_id, do: "some discord_id#{System.unique_integer([:positive])}"

  @doc """
  Generate a discord_user.
  """
  def discord_user_fixture(attrs \\ %{}) do
    {:ok, discord_user} =
      attrs
      |> Enum.into(%{
        avatar: "some avatar",
        discord_id: unique_discord_user_discord_id(),
        discriminator: "some discriminator",
        username: "some username"
      })
      |> Motm.Discord.create_discord_user()

    discord_user
  end

  @doc """
  Generate a unique discord_message discord_id.
  """
  def unique_discord_message_discord_id, do: "some discord_id#{System.unique_integer([:positive])}"

  @doc """
  Generate a discord_message.
  """
  def discord_message_fixture(attrs \\ %{}) do
    {:ok, discord_message} =
      attrs
      |> Enum.into(%{
        channel_id: "some channel_id",
        content: "some content",
        discord_id: unique_discord_message_discord_id(),
        guild_id: "some guild_id"
      })
      |> Motm.Discord.create_discord_message()

    discord_message
  end
end
