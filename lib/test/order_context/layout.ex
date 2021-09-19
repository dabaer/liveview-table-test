defmodule Test.OrderContext.Layout do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @foreign_key_type :binary_id
  schema "layouts" do
    field :id, :integer, primary_key: true
    field :matrix, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(layout, attrs) do
    layout
    |> cast(attrs, [:matrix])
    |> validate_required([:matrix])
  end
end
