defmodule Test.Repo.Migrations.CreateLayouts do
  use Ecto.Migration

  def change do
    create table(:layouts, primary_key: false) do
      add :id, :integer, primary_key: true
      add :matrix, {:array, :string}

      timestamps()
    end
  end
end
