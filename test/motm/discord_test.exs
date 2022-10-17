defmodule Motm.DiscordTest do
  use Motm.DataCase

  alias Motm.Discord

  describe "discord_users" do
    alias Motm.Discord.DiscordUser

    import Motm.DiscordFixtures

    @invalid_attrs %{avatar: nil, discord_id: nil, discriminator: nil, username: nil}

    test "list_discord_users/0 returns all discord_users" do
      discord_user = discord_user_fixture()
      assert Discord.list_discord_users() == [discord_user]
    end

    test "get_discord_user!/1 returns the discord_user with given id" do
      discord_user = discord_user_fixture()
      assert Discord.get_discord_user!(discord_user.id) == discord_user
    end

    test "create_discord_user/1 with valid data creates a discord_user" do
      valid_attrs = %{avatar: "some avatar", discord_id: "some discord_id", discriminator: "some discriminator", username: "some username"}

      assert {:ok, %DiscordUser{} = discord_user} = Discord.create_discord_user(valid_attrs)
      assert discord_user.avatar == "some avatar"
      assert discord_user.discord_id == "some discord_id"
      assert discord_user.discriminator == "some discriminator"
      assert discord_user.username == "some username"
    end

    test "create_discord_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Discord.create_discord_user(@invalid_attrs)
    end

    test "update_discord_user/2 with valid data updates the discord_user" do
      discord_user = discord_user_fixture()
      update_attrs = %{avatar: "some updated avatar", discord_id: "some updated discord_id", discriminator: "some updated discriminator", username: "some updated username"}

      assert {:ok, %DiscordUser{} = discord_user} = Discord.update_discord_user(discord_user, update_attrs)
      assert discord_user.avatar == "some updated avatar"
      assert discord_user.discord_id == "some updated discord_id"
      assert discord_user.discriminator == "some updated discriminator"
      assert discord_user.username == "some updated username"
    end

    test "update_discord_user/2 with invalid data returns error changeset" do
      discord_user = discord_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Discord.update_discord_user(discord_user, @invalid_attrs)
      assert discord_user == Discord.get_discord_user!(discord_user.id)
    end

    test "delete_discord_user/1 deletes the discord_user" do
      discord_user = discord_user_fixture()
      assert {:ok, %DiscordUser{}} = Discord.delete_discord_user(discord_user)
      assert_raise Ecto.NoResultsError, fn -> Discord.get_discord_user!(discord_user.id) end
    end

    test "change_discord_user/1 returns a discord_user changeset" do
      discord_user = discord_user_fixture()
      assert %Ecto.Changeset{} = Discord.change_discord_user(discord_user)
    end
  end

  describe "discord_messages" do
    alias Motm.Discord.DiscordMessage

    import Motm.DiscordFixtures

    @invalid_attrs %{channel_id: nil, content: nil, discord_id: nil, guild_id: nil}

    test "list_discord_messages/0 returns all discord_messages" do
      discord_message = discord_message_fixture()
      assert Discord.list_discord_messages() == [discord_message]
    end

    test "get_discord_message!/1 returns the discord_message with given id" do
      discord_message = discord_message_fixture()
      assert Discord.get_discord_message!(discord_message.id) == discord_message
    end

    test "create_discord_message/1 with valid data creates a discord_message" do
      valid_attrs = %{channel_id: "some channel_id", content: "some content", discord_id: "some discord_id", guild_id: "some guild_id"}

      assert {:ok, %DiscordMessage{} = discord_message} = Discord.create_discord_message(valid_attrs)
      assert discord_message.channel_id == "some channel_id"
      assert discord_message.content == "some content"
      assert discord_message.discord_id == "some discord_id"
      assert discord_message.guild_id == "some guild_id"
    end

    test "create_discord_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Discord.create_discord_message(@invalid_attrs)
    end

    test "update_discord_message/2 with valid data updates the discord_message" do
      discord_message = discord_message_fixture()
      update_attrs = %{channel_id: "some updated channel_id", content: "some updated content", discord_id: "some updated discord_id", guild_id: "some updated guild_id"}

      assert {:ok, %DiscordMessage{} = discord_message} = Discord.update_discord_message(discord_message, update_attrs)
      assert discord_message.channel_id == "some updated channel_id"
      assert discord_message.content == "some updated content"
      assert discord_message.discord_id == "some updated discord_id"
      assert discord_message.guild_id == "some updated guild_id"
    end

    test "update_discord_message/2 with invalid data returns error changeset" do
      discord_message = discord_message_fixture()
      assert {:error, %Ecto.Changeset{}} = Discord.update_discord_message(discord_message, @invalid_attrs)
      assert discord_message == Discord.get_discord_message!(discord_message.id)
    end

    test "delete_discord_message/1 deletes the discord_message" do
      discord_message = discord_message_fixture()
      assert {:ok, %DiscordMessage{}} = Discord.delete_discord_message(discord_message)
      assert_raise Ecto.NoResultsError, fn -> Discord.get_discord_message!(discord_message.id) end
    end

    test "change_discord_message/1 returns a discord_message changeset" do
      discord_message = discord_message_fixture()
      assert %Ecto.Changeset{} = Discord.change_discord_message(discord_message)
    end
  end

  describe "discord_channels" do
    alias Motm.Discord.DiscordChannel

    import Motm.DiscordFixtures

    @invalid_attrs %{discord_id: nil, guild_id: nil, name: nil}

    test "list_discord_channels/0 returns all discord_channels" do
      discord_channel = discord_channel_fixture()
      assert Discord.list_discord_channels() == [discord_channel]
    end

    test "get_discord_channel!/1 returns the discord_channel with given id" do
      discord_channel = discord_channel_fixture()
      assert Discord.get_discord_channel!(discord_channel.id) == discord_channel
    end

    test "create_discord_channel/1 with valid data creates a discord_channel" do
      valid_attrs = %{discord_id: "some discord_id", guild_id: "some guild_id", name: "some name"}

      assert {:ok, %DiscordChannel{} = discord_channel} = Discord.create_discord_channel(valid_attrs)
      assert discord_channel.discord_id == "some discord_id"
      assert discord_channel.guild_id == "some guild_id"
      assert discord_channel.name == "some name"
    end

    test "create_discord_channel/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Discord.create_discord_channel(@invalid_attrs)
    end

    test "update_discord_channel/2 with valid data updates the discord_channel" do
      discord_channel = discord_channel_fixture()
      update_attrs = %{discord_id: "some updated discord_id", guild_id: "some updated guild_id", name: "some updated name"}

      assert {:ok, %DiscordChannel{} = discord_channel} = Discord.update_discord_channel(discord_channel, update_attrs)
      assert discord_channel.discord_id == "some updated discord_id"
      assert discord_channel.guild_id == "some updated guild_id"
      assert discord_channel.name == "some updated name"
    end

    test "update_discord_channel/2 with invalid data returns error changeset" do
      discord_channel = discord_channel_fixture()
      assert {:error, %Ecto.Changeset{}} = Discord.update_discord_channel(discord_channel, @invalid_attrs)
      assert discord_channel == Discord.get_discord_channel!(discord_channel.id)
    end

    test "delete_discord_channel/1 deletes the discord_channel" do
      discord_channel = discord_channel_fixture()
      assert {:ok, %DiscordChannel{}} = Discord.delete_discord_channel(discord_channel)
      assert_raise Ecto.NoResultsError, fn -> Discord.get_discord_channel!(discord_channel.id) end
    end

    test "change_discord_channel/1 returns a discord_channel changeset" do
      discord_channel = discord_channel_fixture()
      assert %Ecto.Changeset{} = Discord.change_discord_channel(discord_channel)
    end
  end
end
