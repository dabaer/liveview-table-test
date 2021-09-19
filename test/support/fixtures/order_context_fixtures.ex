defmodule Test.OrderContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Test.OrderContext` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        bol: "some bol",
        cod: "120.5",
        comment: "some comment",
        consignee: "some consignee",
        customer: "some customer",
        delivery: "some delivery",
        dl_date: ~N[2021-09-17 02:23:00],
        dl_dt_type: "some dl_dt_type",
        dv: "120.5",
        instruction: "some instruction",
        pickup: "some pickup",
        pu_date: ~N[2021-09-17 02:23:00],
        pu_dt_type: "some pu_dt_type",
        shipper: "some shipper",
        terms: "some terms"
      })
      |> Test.OrderContext.create_order()

    order
  end
end
