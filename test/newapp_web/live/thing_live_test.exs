defmodule NewappWeb.ThingLiveTest do
  use NewappWeb.ConnCase

  import Phoenix.LiveViewTest
  import Newapp.DomainFixtures

  @create_attrs %{description: "some description"}
  @update_attrs %{description: "some updated description"}
  @invalid_attrs %{description: nil}
  defp create_thing(_) do
    thing = thing_fixture()

    %{thing: thing}
  end

  describe "Index" do
    setup [:create_thing]

    test "lists all things", %{conn: conn, thing: thing} do
      {:ok, _index_live, html} = live(conn, ~p"/things")

      assert html =~ "Listing Things"
      assert html =~ thing.description
    end

    test "saves new thing", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/things")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Thing")
               |> render_click()
               |> follow_redirect(conn, ~p"/things/new")

      assert render(form_live) =~ "New Thing"

      assert form_live
             |> form("#thing-form", thing: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#thing-form", thing: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/things")

      html = render(index_live)
      assert html =~ "Thing created successfully"
      assert html =~ "some description"
    end

    test "updates thing in listing", %{conn: conn, thing: thing} do
      {:ok, index_live, _html} = live(conn, ~p"/things")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#things-#{thing.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/things/#{thing}/edit")

      assert render(form_live) =~ "Edit Thing"

      assert form_live
             |> form("#thing-form", thing: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#thing-form", thing: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/things")

      html = render(index_live)
      assert html =~ "Thing updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes thing in listing", %{conn: conn, thing: thing} do
      {:ok, index_live, _html} = live(conn, ~p"/things")

      assert index_live
             |> element("#things-#{thing.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#things-#{thing.id}")
    end
  end

  describe "Show" do
    setup [:create_thing]

    test "displays thing", %{conn: conn, thing: thing} do
      {:ok, _show_live, html} = live(conn, ~p"/things/#{thing}")

      assert html =~ "Show Thing"
      assert html =~ thing.description
    end

    test "updates thing and returns to show", %{conn: conn, thing: thing} do
      {:ok, show_live, _html} = live(conn, ~p"/things/#{thing}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(
                 conn,
                 ~p"/things/#{thing}/edit?return_to=show"
               )

      assert render(form_live) =~ "Edit Thing"

      assert form_live
             |> form("#thing-form", thing: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#thing-form", thing: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/things/#{thing}")

      html = render(show_live)
      assert html =~ "Thing updated successfully"
      assert html =~ "some updated description"
    end
  end
end
