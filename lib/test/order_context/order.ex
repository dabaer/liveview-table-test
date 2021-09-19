defmodule Test.OrderContext.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    field :bol, :string
    field :cod, :decimal
    field :comment, :string
    field :consignee, :string
    field :customer, :string
    field :delivery, :string
    field :dl_date, :naive_datetime
    field :dl_dt_type, :string
    field :dv, :decimal
    field :instruction, :string
    field :pickup, :string
    field :pu_date, :naive_datetime
    field :pu_dt_type, :string
    field :shipper, :string
    field :terms, :string

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:customer, :bol, :terms, :shipper, :pickup, :consignee, :delivery, :pu_date, :dl_date, :pu_dt_type, :dl_dt_type, :comment, :instruction, :cod, :dv])
    |> validate_required([:customer, :bol, :terms, :shipper, :pickup, :consignee, :delivery, :pu_date, :dl_date, :pu_dt_type, :dl_dt_type, :comment, :instruction, :cod, :dv])
  end
end
