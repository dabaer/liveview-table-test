defmodule Test.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :customer, :string
      add :bol, :string
      add :terms, :string
      add :shipper, :string
      add :pickup, :string
      add :consignee, :string
      add :delivery, :string
      add :pu_date, :naive_datetime
      add :dl_date, :naive_datetime
      add :pu_dt_type, :string
      add :dl_dt_type, :string
      add :comment, :string
      add :instruction, :string
      add :cod, :decimal
      add :dv, :decimal

      timestamps()
    end
  end
end
