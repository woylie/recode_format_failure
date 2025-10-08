defmodule NewappWeb.ThingLive.Show do
  use NewappWeb, :live_view

  alias Newapp.Domain

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Thing {@thing.id}
        <:subtitle>This is a thing record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/things"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button
            variant="primary"
            navigate={~p"/things/#{@thing}/edit?return_to=show"}
          >
            <.icon name="hero-pencil-square" /> Edit thing
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Description">{@thing.description}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Thing")
     |> assign(:thing, Domain.get_thing!(id))}
  end
end
