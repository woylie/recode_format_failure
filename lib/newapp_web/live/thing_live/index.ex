defmodule NewappWeb.ThingLive.Index do
  use NewappWeb, :live_view

  alias Newapp.Domain

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Things
        <:actions>
          <.button variant="primary" navigate={~p"/things/new"}>
            <.icon name="hero-plus" /> New Thing
          </.button>
        </:actions>
      </.header>

      <.table
        id="things"
        rows={@streams.things}
        row_click={fn {_id, thing} -> JS.navigate(~p"/things/#{thing}") end}
      >
        <:col :let={{_id, thing}} label="Description">{thing.description}</:col>
        <:action :let={{_id, thing}}>
          <div class="sr-only">
            <.link navigate={~p"/things/#{thing}"}>Show</.link>
          </div>
          <.link navigate={~p"/things/#{thing}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, thing}}>
          <.link
            phx-click={JS.push("delete", value: %{id: thing.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Things")
     |> stream(:things, list_things())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    thing = Domain.get_thing!(id)
    {:ok, _} = Domain.delete_thing(thing)

    {:noreply, stream_delete(socket, :things, thing)}
  end

  defp list_things() do
    Domain.list_things()
  end
end
