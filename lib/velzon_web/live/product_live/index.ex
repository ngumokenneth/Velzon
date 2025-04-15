defmodule VelzonWeb.ProductLive.Index do
  use VelzonWeb, :live_view

  alias Velzon.Products
  alias Velzon.Products.Product
  alias Velzon.Products.ProductInfo
  alias Velzon.Products.ProductMeta

  @steps %{
    "product_info" => 1,
    "meta_info" => 2
  }

  def render(assigns) do
    ~H"""
    <.header class="bg-white">
      CREATE PRODUCT
    </.header>
    <div>
      <.form for={@form}>
        <div>
          <.input label="Product Title" field={@form[:name]} placeholder="Enter product name" />
          <.input
            label="Product Description"
            field={@form[:product_description]}
            placeholder="Enter product Description"
          />
        </div>
        <div class="flex gap-5 my-5">
          <ol>
            <li>
              <.link patch={~p"/products/step?#{[step: "product_info"]}"}>
                Product General info
              </.link>
            </li>
          </ol>
          <ol>
            <li>
              <.link patch={~p"/products/step?#{[step: "meta_info"]}"}>
                Product Meta info
              </.link>
            </li>
          </ol>
        </div>
        <div>
          <%= if @current_step == 1 do %>
            <.inputs_for :let={product_info} field={@form[:product_info]}>
              <.input type="text" label="Manufacturer Name" field={product_info[:manufacturer]} />
              <.input type="text" label="Manufacturer Brand" field={product_info[:brand]} />
              <.input type="text" label="Stocks" field={product_info[:stocks]} />
              <.input type="text" label="Price" field={product_info[:price]} />
              <.input type="text" label="Discount" field={product_info[:discount]} />
              <.input type="text" label="Orders" field={product_info[:orders]} />
            </.inputs_for>
          <% end %>
        </div>

        <div>
          <%= if @current_step == 2 do %>
            <.inputs_for :let={product_meta} field={@form[:product_meta]}>
              <.input type="text" label="Meta Title" field={product_meta[:title]} />
              <.input type="text" label="Meta Keywords" field={product_meta[:keywords]} />
              <.input type="text" label="Meta Description" field={product_meta[:description]} />
            </.inputs_for>
          <% end %>
        </div>

        <.button>Submit</.button>
      </.form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_form(Products.change_product())
     |> IO.inspect(label: "==== socket +++")}
  end

  def handle_params(params, _uri, socket) do
    step = Map.get(params, "step", "product_info")
    current_step = Map.get(@steps, step, 1)
    {:noreply, assign(socket, :current_step, current_step)}
  end

  defp assign_form(socket, changeset) do
    form = to_form(changeset, as: "product")
    assign(socket, :form, form)
  end

  # def nav_class(min_step, current_step) when current_step >= min_step do
  #   "group flex flex-col border-l-4 border-indigo-600 py-2 pl-4 hover:border-indigo-800 md:border-l-0 md:border-t-4 md:pb-0 md:pl-0 md:pt-4"
  # end

  # def nav_class(_min_step, _current_step) do
  #   "group flex flex-col border-l-4 border-gray-200 py-2 pl-4 hover:border-gray-300 md:border-l-0 md:border-t-4 md:pb-0 md:pl-0 md:pt-4"
  # end

  # def title_class(min_step, current_step) when current_step >= min_step do
  #   "text-sm font-medium text-indigo-600 group-hover:text-indigo-800"
  # end

  # def title_class(_min_step, _current_step) do
  #   "text-sm font-medium text-gray-500 group-hover:text-gray-700"
  # end
end
