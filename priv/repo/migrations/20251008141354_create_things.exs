defmodule Newapp.Repo.Migrations.CreateThings do
  use Ecto.Migration

  def change do
    create table(:things) do
      add :description, :text

      timestamps(type: :utc_datetime)
    end
  end
end
