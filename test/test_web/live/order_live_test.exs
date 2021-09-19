defmodule TestWeb.OrderLiveTest do
  use TestWeb.ConnCase

  import Phoenix.LiveViewTest
  import Test.OrderContextFixtures

  @create_attrs %{bol: "some bol", cod: "120.5", comment: "some comment", consignee: "some consignee", customer: "some customer", delivery: "some delivery", dl_date: %{day: 17, hour: 2, minute: 23, month: 9, year: 2021}, dl_dt_type: "some dl_dt_type", dv: "120.5", instruction: "some instruction", pickup: "some pickup", pu_date: %{day: 17, hour: 2, minute: 23, month: 9, year: 2021}, pu_dt_type: "some pu_dt_type", shipper: "some shipper", terms: "some terms"}
  @update_attrs %{bol: "some updated bol", cod: "456.7", comment: "some updated comment", consignee: "some updated consignee", customer: "some updated customer", delivery: "some updated delivery", dl_date: %{day: 18, hour: 2, minute: 23, month: 9, year: 2021}, dl_dt_type: "some updated dl_dt_type", dv: "456.7", instruction: "some updated instruction", pickup: "some updated pickup", pu_date: %{day: 18, hour: 2, minute: 23, month: 9, year: 2021}, pu_dt_type: "some updated pu_dt_type", shipper: "some updated shipper", terms: "some updated terms"}
  @invalid_attrs %{bol: nil, cod: nil, comment: nil, consignee: nil, customer: nil, delivery: nil, dl_date: %{day: 30, hour: 2, minute: 23, month: 2, year: 2021}, dl_dt_type: nil, dv: nil, instruction: nil, pickup: nil, pu_date: %{day: 30, hour: 2, minute: 23, month: 2, year: 2021}, pu_dt_type: nil, shipper: nil, terms: nil}

  defp create_order(_) do
    order = order_fixture()
    %{order: order}
  end

  describe "Index" do
    setup [:create_order]

    test "lists all orders", %{conn: conn, order: order} do
      {:ok, _index_live, html} = live(conn, Routes.order_index_path(conn, :index))

      assert html =~ "Listing Orders"
      assert html =~ order.bol
    end

    test "saves new order", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.order_index_path(conn, :index))

      assert index_live |> element("a", "New Order") |> render_click() =~
               "New Order"

      assert_patch(index_live, Routes.order_index_path(conn, :new))

      assert index_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#order-form", order: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.order_index_path(conn, :index))

      assert html =~ "Order created successfully"
      assert html =~ "some bol"
    end

    test "updates order in listing", %{conn: conn, order: order} do
      {:ok, index_live, _html} = live(conn, Routes.order_index_path(conn, :index))

      assert index_live |> element("#order-#{order.id} a", "Edit") |> render_click() =~
               "Edit Order"

      assert_patch(index_live, Routes.order_index_path(conn, :edit, order))

      assert index_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#order-form", order: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.order_index_path(conn, :index))

      assert html =~ "Order updated successfully"
      assert html =~ "some updated bol"
    end

    test "deletes order in listing", %{conn: conn, order: order} do
      {:ok, index_live, _html} = live(conn, Routes.order_index_path(conn, :index))

      assert index_live |> element("#order-#{order.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#order-#{order.id}")
    end
  end

  describe "Show" do
    setup [:create_order]

    test "displays order", %{conn: conn, order: order} do
      {:ok, _show_live, html} = live(conn, Routes.order_show_path(conn, :show, order))

      assert html =~ "Show Order"
      assert html =~ order.bol
    end

    test "updates order within modal", %{conn: conn, order: order} do
      {:ok, show_live, _html} = live(conn, Routes.order_show_path(conn, :show, order))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Order"

      assert_patch(show_live, Routes.order_show_path(conn, :edit, order))

      assert show_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#order-form", order: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.order_show_path(conn, :show, order))

      assert html =~ "Order updated successfully"
      assert html =~ "some updated bol"
    end
  end
end
