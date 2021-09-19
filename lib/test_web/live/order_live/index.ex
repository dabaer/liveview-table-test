defmodule TestWeb.OrderLive.Index do
  use TestWeb, :live_view

  alias Test
  alias Test.OrderContext
  alias Test.OrderContext.Order

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
      |> assign(:orders, OrderContext.list_orders())
      |> assign(:columns, OrderContext.order_columns())
      |> assign(:column_layout, OrderContext.get_layout())
      |> assign(:col, "id")
      |> assign(:dir, "asc")

    {:ok, socket, temporary_assigns: [orders: []]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Order")
    |> assign(:order, OrderContext.get_order!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Order")
    |> assign(:order, %Order{})
  end

  defp apply_action(socket, :columns, _params) do
    socket
    |> assign(:page_title, "Adjust Columns")
    |> assign(:columns, OrderContext.order_columns())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Orders")
    |> assign(:order, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    order = OrderContext.get_order!(id)
    {:ok, _} = OrderContext.delete_order(order)

    {:noreply, assign(socket, :orders, OrderContext.list_orders())}
  end

  def handle_event("dropped", %{"id" => item, "index" => index}, socket) do
    socket = case OrderContext.move_column(item, index) do
      :nochange ->
        socket
      _ ->
        socket
        |> assign(:orders, OrderContext.list_orders(socket.assigns.col, socket.assigns.dir))
        |> assign(:columns, OrderContext.order_columns())
        |> assign(:column_layout, OrderContext.get_layout())
    end

    {:noreply, socket}
  end

  def handle_event("sort", %{"col" => col, "dir" => dir}, socket) do
    socket = socket
      |> assign(:orders, OrderContext.list_orders(col, dir))
      |> assign(:col, col)
      |> assign(:dir, dir)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:apply_layout, layout}, socket) do
    {:noreply, assign(socket, column_layout: layout)}
  end

  def header(assigns) do
    case Map.get(assigns[:columns], assigns[:column]) do
      [column, _] ->
        ~H"""
        <th id={@column} phx-click="sort" phx-value-col={@column} phx-value-dir={get_dir(@col, @column, @dir)} class="draggable" draggable="true">
          <%= column %><.dir col={@col} column={@column} dir={@dir}></.dir>
        </th>
        """
      column ->
        ~H"""
        <th id={@column} phx-click="sort" phx-value-col={@column} phx-value-dir={get_dir(@col, @column, @dir)} class="draggable" draggable="true">
          <%= column %><.dir col={@col} column={@column} dir={@dir}></.dir>
        </th>
        """
    end
  end

  defp dir(assigns) do
    if assigns[:column] == assigns[:col] do
      ~H"""
      <i><%= if @dir == "desc" do %>⏷<% else %>⏶<% end %></i>
      """
    else
      ~H"""
      """
    end
  end

  def get_dir(col, column, dir) do
    if col == column and dir == "asc" do
      "desc"
    else
      "asc"
    end
  end

  def field(assigns) do
    case Map.get(assigns[:columns], assigns[:column]) do
      [_, :time] ->
        ~H"""
        <td><%= Test.ts(Map.get(@order, String.to_existing_atom(@column))) %></td>
        """
      [_, :order] ->
        ~H"""
        <td><%= String.slice(Map.get(@order, String.to_existing_atom(@column)), 0..7) %></td>
        """
      _ ->
        ~H"""
        <td><%= Map.get(@order, String.to_existing_atom(@column)) %></td>
        """
    end
  end
end
