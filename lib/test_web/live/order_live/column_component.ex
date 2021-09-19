defmodule TestWeb.OrderLive.ColumnComponent do
  use TestWeb, :live_component

  alias Test.OrderContext

  @impl true
  def update(%{column_layout: layout, columns: columns} = assigns, socket) do
    changeset = OrderContext.change_layout(layout)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:columns, columns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="column-form">
      <.form let={f} for={@changeset} id="column-form" phx-target={@myself} phx-submit="apply">
        <div class="fx">
          <%= for {field, name} <- @columns do %>
            <label>
              <%= checkbox f, String.to_existing_atom(field), checked: field in @changeset.data.matrix %>
              <%= get_name(name) %>
            </label>
          <% end %>
        </div>

        <%= submit "Save", phx_disable_with: "Saving..." %>
      </.form>
      <button phx-target={@myself} phx-click="apply_default">Default</button>
    </div>
    """
  end

  @impl true
  def handle_event("apply_default", _, socket) do
    {:ok, layout} = OrderContext.default_columns()
    |> OrderContext.save_layout()

    send(self(), {:apply_layout, layout})

    {:noreply, push_redirect(socket, to: socket.assigns.return_to)}
  end

  def handle_event("apply", %{"layout" => layout}, socket) do
    {:ok, layout} = layout
    |> OrderContext.reduce_layout()
    |> OrderContext.save_layout()

    send(self(), {:apply_layout, layout})

    {:noreply, push_redirect(socket, to: socket.assigns.return_to)}
  end

  def get_name(name) do
    case name do
      [name, _] -> name
      name -> name
    end
  end
end
