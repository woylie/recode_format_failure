defmodule Newapp.Domain.Thing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "things" do
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(thing, attrs) do
    thing
    |> cast(attrs, [:description])
    |> validate_required([:description])
  end
end
