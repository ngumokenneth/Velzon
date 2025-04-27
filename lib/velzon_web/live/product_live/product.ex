defmodule VelzonWeb.ProductLive.Product do
  use VelzonWeb, :live_view

  alias Velzon.Products
  alias VelzonWeb.ProductLive.ProductForm

  @steps %{
    "product" => 1,
    "product_info" => 2,
    "product_meta" => 3,
    "review" => 4
  }

  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-3">
      <div class="col-span-2">
        <div class="border-b-orange-800">
          <.link patch={~p"/products/steps?#{[step: "product"]}"} class="p-2 ">
            Product starting Information
          </.link>
          <.link patch={~p"/products/steps?#{[step: "product_info"]}"} class="p-2 ">
            Product General Information
          </.link>
          <.link patch={~p"/products/steps?#{[step: "product_meta"]}"} class="p-2 ">
            Product Meta Information
          </.link>
        </div>
        <hr class="border-t-rose-400" />
        <.simple_form for={@form} phx-change="validate" phx-submit="submit" class="rounded-lg">
          <%= if @current_step == 1 do %>
            <div>
              <.input type="text" label="Product Title" field={@form[:name]} />
              <.input type="text" label="Product Description" field={@form[:product_description]} />
              <div class="flex justify-end">
                <.button type="submit">
                  Next step <.icon name="hero-arrow-right" class="h-5" />
                </.button>
              </div>
            </div>
          <% end %>
          <%= if @current_step == 2 do %>
            <div class="mt-8 grid grid-cols-3 gap-4 p-3 ">
              <.inputs_for :let={product_info} field={@form[:product_info]}>
                <.input type="text" label="Product Title" field={product_info[:manufacturer]} />
                <.input type="text" label="brand" field={product_info[:brand]} />
                <.input type="number" label="stocks" field={product_info[:stocks]} />

                <.input type="number" label="Price" field={product_info[:price]} />

                <.input type="number" label="Discount" field={product_info[:discount]} />
                <.input type="number" label="Orders" field={product_info[:orders]} />
              </.inputs_for>
            </div>
            <div class="flex justify-end w-full">
              <.button type="submit">
                Next step <.icon name="hero-arrow-right" class="h-5" />
              </.button>
            </div>
          <% end %>
          <%= if @current_step == 3 do %>
            <div class="mt-8 gap-4">
              <.inputs_for :let={product_meta} field={@form[:product_meta]}>
                <div class="flex justify-between">
                  <.input type="text" label="Meta Title" field={product_meta[:title]} />
                  <.input type="text" label="keywords" field={product_meta[:keywords]} />
                </div>
                <.input type="text" label="description" field={product_meta[:description]} />
              </.inputs_for>
              <div class="flex justify-end">
                <.button type="submit">
                  Next step <.icon name="hero-arrow-right" class="h-5" />
                </.button>
              </div>
            </div>
          <% end %>
          <%= if @current_step == 4 do %>
            <div>
              <.input type="text" label="Product Title" field={@form[:name]} />
              <.input type="text" label="Product Description" field={@form[:product_description]} />
            </div>
            <div class="mt-8 grid grid-cols-3 gap-4">
              <.inputs_for :let={product_info} field={@form[:product_info]}>
                <.input type="text" label="Product Title" field={product_info[:manufacturer]} />
                <.input type="text" label="brand" field={product_info[:brand]} />
                <.input type="number" label="stocks" field={product_info[:stocks]} />
                <.input type="number" label="Price" field={product_info[:price]} />
                <.input type="number" label="Discount" field={product_info[:discount]} />
                <.input type="number" label="Orders" field={product_info[:orders]} />
              </.inputs_for>
            </div>
            <div class="mt-8 gap-4">
              <.inputs_for :let={product_meta} field={@form[:product_meta]}>
                <.input type="text" label="Meta Title" field={product_meta[:title]} />
                <.input type="text" label="keywords" field={product_meta[:keywords]} />
                <.input type="text" label="description" field={product_meta[:description]} />
              </.inputs_for>
              <.button type="submit">submit</.button>
            </div>
          <% end %>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign_form(socket, ProductForm.new())}
  end

  def handle_params(params, _uri, socket) do
    step = Map.get(params, "step", "product")
    current_step = Map.get(@steps, step, 1)
    {:noreply, assign(socket, :current_step, current_step)}
  end

  def handle_event("validate", %{"product_form" => product_params}, socket) do
    changeset = ProductForm.validate(socket.assigns.form, product_params)
    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("submit", %{"product_form" => product_params}, socket) do
    current_step = socket.assigns.current_step
    {:noreply, handle_submit(socket, current_step, product_params)}
  end

  defp handle_submit(socket, current_step, product_params) when current_step in 1..3 do
    case ProductForm.submit(socket.assigns.form, product_params) do
      {:ok, %ProductForm{} = data} ->
        changeset = ProductForm.new(data)

        socket
        |> update(:current_step, &(&1 + 1))
        |> assign_form(changeset)

      {:error, changeset} ->
        assign_form(socket, changeset)
    end
  end

  defp handle_submit(socket, 4, product_params) do
    form = socket.assigns.form
    user = socket.assigns.current_user

    with {:ok, %{product: product_data}} <- ProductForm.form_submit(form, product_params) do
      Products.create_product(product_data, user)
      |> case do
        {:ok, :created, _product} ->
          socket
          |> put_flash(:info, "Product Created successfully")
          |> push_navigate(to: ~p"/products")

        {:error, :form, changeset} ->
          assign_form(socket, changeset)
      end
    end
  end

  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
