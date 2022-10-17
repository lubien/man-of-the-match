defmodule MotmWeb.DiscordMessageLiveTest do
  use MotmWeb.ConnCase

  import Phoenix.LiveViewTest
  import Motm.DiscordFixtures

  @create_attrs %{channel_id: "some channel_id", content: "some content", discord_id: "some discord_id", guild_id: "some guild_id"}
  @update_attrs %{channel_id: "some updated channel_id", content: "some updated content", discord_id: "some updated discord_id", guild_id: "some updated guild_id"}
  @invalid_attrs %{channel_id: nil, content: nil, discord_id: nil, guild_id: nil}

  defp create_discord_message(_) do
    discord_message = discord_message_fixture()
    %{discord_message: discord_message}
  end

  describe "Index" do
    setup [:create_discord_message]

    test "lists all discord_messages", %{conn: conn, discord_message: discord_message} do
      {:ok, _index_live, html} = live(conn, ~p"/discord_messages")

      assert html =~ "Listing Discord messages"
      assert html =~ discord_message.channel_id
    end

    test "saves new discord_message", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/discord_messages")

      assert index_live |> element("a", "New Discord message") |> render_click() =~
               "New Discord message"

      assert_patch(index_live, ~p"/discord_messages/new")

      assert index_live
             |> form("#discord_message-form", discord_message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#discord_message-form", discord_message: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/discord_messages")

      assert html =~ "Discord message created successfully"
      assert html =~ "some channel_id"
    end

    test "updates discord_message in listing", %{conn: conn, discord_message: discord_message} do
      {:ok, index_live, _html} = live(conn, ~p"/discord_messages")

      assert index_live |> element("#discord_messages-#{discord_message.id} a", "Edit") |> render_click() =~
               "Edit Discord message"

      assert_patch(index_live, ~p"/discord_messages/#{discord_message}/edit")

      assert index_live
             |> form("#discord_message-form", discord_message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#discord_message-form", discord_message: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/discord_messages")

      assert html =~ "Discord message updated successfully"
      assert html =~ "some updated channel_id"
    end

    test "deletes discord_message in listing", %{conn: conn, discord_message: discord_message} do
      {:ok, index_live, _html} = live(conn, ~p"/discord_messages")

      assert index_live |> element("#discord_messages-#{discord_message.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#discord_message-#{discord_message.id}")
    end
  end

  describe "Show" do
    setup [:create_discord_message]

    test "displays discord_message", %{conn: conn, discord_message: discord_message} do
      {:ok, _show_live, html} = live(conn, ~p"/discord_messages/#{discord_message}")

      assert html =~ "Show Discord message"
      assert html =~ discord_message.channel_id
    end

    test "updates discord_message within modal", %{conn: conn, discord_message: discord_message} do
      {:ok, show_live, _html} = live(conn, ~p"/discord_messages/#{discord_message}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Discord message"

      assert_patch(show_live, ~p"/discord_messages/#{discord_message}/show/edit")

      assert show_live
             |> form("#discord_message-form", discord_message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#discord_message-form", discord_message: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/discord_messages/#{discord_message}")

      assert html =~ "Discord message updated successfully"
      assert html =~ "some updated channel_id"
    end
  end
end
