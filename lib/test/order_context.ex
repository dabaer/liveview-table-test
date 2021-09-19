defmodule Test.OrderContext do
  @moduledoc """
  The OrderContext context.
  """

  import Ecto.Query, warn: false
  alias Test.Repo

  alias Test.OrderContext.{Layout, Order}

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders(sort \\ "id", dir \\ "asc") do
    sort = if Map.has_key?(order_columns(), sort) do String.to_existing_atom(sort) else :id end
    dir = if dir == "desc" do :desc else :asc end

    Repo.all(from o in Order, order_by: [{^dir, ^sort}])
  end

  def order_columns do
    %{
      "id" => ["Order #", :order],
      "customer" => "Customer",
      "bol" => "BOL",
      "consignee" => "Consignee",
      "pickup" => "Pickup At",
      "shipper" => "Shipper",
      "delivery" => "Deliver To",
      "dl_date" => ["Delivery Date", :time],
      "pu_date" => ["Pickup Date", :time],
      "terms" => "Terms",
      "instruction" => "Instruction",
      "cod" => "COD $",
      "dv" => "DV $",
      "comment" => "Comment"
    }
  end

  def default_columns do
    ["id", "pu_date", "pickup", "dl_date", "delivery", "bol"]
  end

  def get_layout do
    Repo.get(Layout, 1) || %Layout{id: 1, matrix: default_columns()}
  end

  def save_layout(layout) do
    get_layout()
    |> change_layout(%{"matrix" => layout})
    |> Repo.insert_or_update()
  end

  def reduce_layout(layout) do
    current = get_layout()
    |> Map.get(:matrix)

    layout
    |> Enum.reduce(current, fn {k, v}, acc ->
      with \
        {:i, false}  <- {:i, is_nil(Map.get(order_columns(), k))},
        false  <- k in current,
        "true" <- v
      do
        acc ++ [k]
      else
        "false" ->
          acc -- [v]
        _ ->
          acc
      end
    end)
  end

  def move_column(item, index) do
    c = order_columns()
    g = get_layout()
      |> Map.get(:matrix)

    if Enum.find_index(g, fn x -> x == item end) == index do
      :nochange
    else
      g
      |> List.delete(item)
      |> List.insert_at(index, item)
      |> Enum.reduce([], fn x, acc ->
        if Map.has_key?(c, x) do acc ++ [x] else acc end
      end)
      |> save_layout()
    end
  end

  def change_layout(%Layout{} = layout, attrs \\ %{}) do
    Layout.changeset(layout, attrs)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id) do
    Repo.get!(Order, id)
  end

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end
end
