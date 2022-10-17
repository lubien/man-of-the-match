defmodule MotmWeb.DiscordUserLiveTest do
  use MotmWeb.ConnCase

  import Phoenix.LiveViewTest
  import Motm.DiscordFixtures

  @create_attrs %{avatar: "some avatar", discord_id: "some discord_id", discriminator: "some discriminator", username: "some username"}
  @update_attrs %{avatar: "some updated avatar", discord_id: "some updated discord_id", discriminator: "some updated discriminator", username: "some updated username"}
  @invalid_attrs %{avatar: nil, discord_id: nil, discriminator: nil, username: nil}

  defp create_discord_user(_) do
    discord_user = discord_user_fixture()
    %{discord_user: discord_user}
  end

  describe "Index" do
    setup [:create_discord_user]

    test "lists all discord_users", %{conn: conn, discord_user: discord_user} do
      {:ok, _index_live, html} = live(conn, ~p"/discord_users")

      assert html =~ "Listing Discord users"
      assert html =~ discord_user.avatar
    end

    test "saves new discord_user", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/discord_users")

      assert index_live |> element("a", "New Discord user") |> render_click() =~
               "New Discord user"

      assert_patch(index_live, ~p"/discord_users/new")

      assert index_live
             |> form("#discord_user-form", discord_user: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#discord_user-form", discord_user: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/discord_users")

      assert html =~ "Discord user created successfully"
      assert html =~ "some avatar"
    end

    test "updates discord_user in listing", %{conn: conn, discord_user: discord_user} do
      {:ok, index_live, _html} = live(conn, ~p"/discord_users")

      assert index_live |> element("#discord_users-#{discord_user.id} a", "Edit") |> render_click() =~
               "Edit Discord user"

      assert_patch(index_live, ~p"/discord_users/#{discord_user}/edit")

      assert index_live
             |> form("#discord_user-form", discord_user: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#discord_user-form", discord_user: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/discord_users")

      assert html =~ "Discord user updated successfully"
      assert html =~ "some updated avatar"
    end

    test "deletes discord_user in listing", %{conn: conn, discord_user: discord_user} do
      {:ok, index_live, _html} = live(conn, ~p"/discord_users")

      assert index_live |> element("#discord_users-#{discord_user.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#discord_user-#{discord_user.id}")
    end
  end

  describe "Show" do
    setup [:create_discord_user]

    test "displays discord_user", %{conn: conn, discord_user: discord_user} do
      {:ok, _show_live, html} = live(conn, ~p"/discord_users/#{discord_user}")

      assert html =~ "Show Discord user"
      assert html =~ discord_user.avatar
    end

    test "updates discord_user within modal", %{conn: conn, discord_user: discord_user} do
      {:ok, show_live, _html} = live(conn, ~p"/discord_users/#{discord_user}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Discord user"

      assert_patch(show_live, ~p"/discord_users/#{discord_user}/show/edit")

      assert show_live
             |> form("#discord_user-form", discord_user: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#discord_user-form", discord_user: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/discord_users/#{discord_user}")

      assert html =~ "Discord user updated successfully"
      assert html =~ "some updated avatar"
    end
  end
end
