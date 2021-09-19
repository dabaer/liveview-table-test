defmodule Test.OrderContextTest do
  use Test.DataCase

  alias Test.OrderContext

  describe "orders" do
    alias Test.OrderContext.Order

    import Test.OrderContextFixtures

    @invalid_attrs %{bol: nil, cod: nil, comment: nil, consignee: nil, customer: nil, delivery: nil, dl_date: nil, dl_dt_type: nil, dv: nil, instruction: nil, pickup: nil, pu_date: nil, pu_dt_type: nil, shipper: nil, terms: nil}

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert OrderContext.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert OrderContext.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{bol: "some bol", cod: "120.5", comment: "some comment", consignee: "some consignee", customer: "some customer", delivery: "some delivery", dl_date: ~N[2021-09-17 02:23:00], dl_dt_type: "some dl_dt_type", dv: "120.5", instruction: "some instruction", pickup: "some pickup", pu_date: ~N[2021-09-17 02:23:00], pu_dt_type: "some pu_dt_type", shipper: "some shipper", terms: "some terms"}

      assert {:ok, %Order{} = order} = OrderContext.create_order(valid_attrs)
      assert order.bol == "some bol"
      assert order.cod == Decimal.new("120.5")
      assert order.comment == "some comment"
      assert order.consignee == "some consignee"
      assert order.customer == "some customer"
      assert order.delivery == "some delivery"
      assert order.dl_date == ~N[2021-09-17 02:23:00]
      assert order.dl_dt_type == "some dl_dt_type"
      assert order.dv == Decimal.new("120.5")
      assert order.instruction == "some instruction"
      assert order.pickup == "some pickup"
      assert order.pu_date == ~N[2021-09-17 02:23:00]
      assert order.pu_dt_type == "some pu_dt_type"
      assert order.shipper == "some shipper"
      assert order.terms == "some terms"
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OrderContext.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      update_attrs = %{bol: "some updated bol", cod: "456.7", comment: "some updated comment", consignee: "some updated consignee", customer: "some updated customer", delivery: "some updated delivery", dl_date: ~N[2021-09-18 02:23:00], dl_dt_type: "some updated dl_dt_type", dv: "456.7", instruction: "some updated instruction", pickup: "some updated pickup", pu_date: ~N[2021-09-18 02:23:00], pu_dt_type: "some updated pu_dt_type", shipper: "some updated shipper", terms: "some updated terms"}

      assert {:ok, %Order{} = order} = OrderContext.update_order(order, update_attrs)
      assert order.bol == "some updated bol"
      assert order.cod == Decimal.new("456.7")
      assert order.comment == "some updated comment"
      assert order.consignee == "some updated consignee"
      assert order.customer == "some updated customer"
      assert order.delivery == "some updated delivery"
      assert order.dl_date == ~N[2021-09-18 02:23:00]
      assert order.dl_dt_type == "some updated dl_dt_type"
      assert order.dv == Decimal.new("456.7")
      assert order.instruction == "some updated instruction"
      assert order.pickup == "some updated pickup"
      assert order.pu_date == ~N[2021-09-18 02:23:00]
      assert order.pu_dt_type == "some updated pu_dt_type"
      assert order.shipper == "some updated shipper"
      assert order.terms == "some updated terms"
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = OrderContext.update_order(order, @invalid_attrs)
      assert order == OrderContext.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = OrderContext.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> OrderContext.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = OrderContext.change_order(order)
    end
  end
end
