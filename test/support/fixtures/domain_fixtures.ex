defmodule Newapp.DomainFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Newapp.Domain` context.
  """

  @doc """
  Generate a thing.
  """
  def thing_fixture(attrs \\ %{}) do
    {:ok, thing} =
      attrs
      |> Enum.into(%{
        description: "some description"
      })
      |> Newapp.Domain.create_thing()

    thing
  end
end
