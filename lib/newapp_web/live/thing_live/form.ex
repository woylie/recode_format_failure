defmodule NewappWeb.ThingLive.Form do
  use NewappWeb, :live_view

  alias Newapp.Domain
  alias Newapp.Domain.Thing

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>
          Use this form to manage thing records in your database.
        </:subtitle>
      </.header>

      <.form for={@form} id="thing-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:description]} type="textarea" label="Description" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">
            Save Thing
          </.button>
          <.button navigate={return_path(@return_to, @thing)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    thing = Domain.get_thing!(id)

    socket
    |> assign(:page_title, "Edit Thing")
    |> assign(:thing, thing)
    |> assign(:form, to_form(Domain.change_thing(thing)))
  end

  defp apply_action(socket, :new, _params) do
    thing = %Thing{}

    socket
    |> assign(:page_title, "New Thing")
    |> assign(:thing, thing)
    |> assign(:form, to_form(Domain.change_thing(thing)))
  end

  @impl true
  def handle_event("validate", %{"thing" => thing_params}, socket) do
    changeset = Domain.change_thing(socket.assigns.thing, thing_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"thing" => thing_params}, socket) do
    save_thing(socket, socket.assigns.live_action, thing_params)
  end

  defp save_thing(socket, :edit, thing_params) do
    case Domain.update_thing(socket.assigns.thing, thing_params) do
      {:ok, thing} ->
        {:noreply,
         socket
         |> put_flash(:info, "Thing updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, thing))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_thing(socket, :new, thing_params) do
    case Domain.create_thing(thing_params) do
      {:ok, thing} ->
        {:noreply,
         socket
         |> put_flash(:info, "Thing created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, thing))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _thing), do: ~p"/things"
  defp return_path("show", thing), do: ~p"/things/#{thing}"
end
