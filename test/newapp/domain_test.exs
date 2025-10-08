defmodule Newapp.DomainTest do
  use Newapp.DataCase

  alias Newapp.Domain

  describe "things" do
    alias Newapp.Domain.Thing

    import Newapp.DomainFixtures

    @invalid_attrs %{description: nil}

    test "list_things/0 returns all things" do
      thing = thing_fixture()
      assert Domain.list_things() == [thing]
    end

    test "get_thing!/1 returns the thing with given id" do
      thing = thing_fixture()
      assert Domain.get_thing!(thing.id) == thing
    end

    test "create_thing/1 with valid data creates a thing" do
      valid_attrs = %{description: "some description"}

      assert {:ok, %Thing{} = thing} = Domain.create_thing(valid_attrs)
      assert thing.description == "some description"
    end

    test "create_thing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Domain.create_thing(@invalid_attrs)
    end

    test "update_thing/2 with valid data updates the thing" do
      thing = thing_fixture()
      update_attrs = %{description: "some updated description"}

      assert {:ok, %Thing{} = thing} = Domain.update_thing(thing, update_attrs)
      assert thing.description == "some updated description"
    end

    test "update_thing/2 with invalid data returns error changeset" do
      thing = thing_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Domain.update_thing(thing, @invalid_attrs)

      assert thing == Domain.get_thing!(thing.id)
    end

    test "delete_thing/1 deletes the thing" do
      thing = thing_fixture()
      assert {:ok, %Thing{}} = Domain.delete_thing(thing)
      assert_raise Ecto.NoResultsError, fn -> Domain.get_thing!(thing.id) end
    end

    test "change_thing/1 returns a thing changeset" do
      thing = thing_fixture()
      assert %Ecto.Changeset{} = Domain.change_thing(thing)
    end
  end
end
