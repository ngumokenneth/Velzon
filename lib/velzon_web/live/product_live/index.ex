defmodule VelzonWeb.ProductLive.Index do
  use VelzonWeb, :live_view

  alias Velzon.Products
  alias Velzon.Products.Product
  alias Velzon.Products.ProductInfo
  alias Velzon.Products.ProductMeta

  # @steps %{
  #   "product_info" => 1,
  #   "meta_info" => 2
  # }

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto">
      <.header class="text-center mb-8">
        CREATE PRODUCT (Step {@current_step} of 3)
      </.header>

      <.form for={@form} phx-change="validate" phx-submit="submit" class="space-y-6">
        <!-- Progress indicator -->
        <div class="flex justify-between mb-8">
          <%= for step <- 1..3 do %>
            <div class={"text-center #{if step == @current_step, do: "font-bold text-blue-600"}"}>
              <div class={"w-8 h-8 mx-auto rounded-full flex items-center justify-center #{if step <= @current_step, do: "bg-blue-100 text-blue-600", else: "bg-gray-100"}"}>
                {step}
              </div>
              <div class="text-xs mt-1">
                <%= case step do %>
                  <% 1 -> %>
                    Basic Info
                  <% 2 -> %>
                    Details
                  <% 3 -> %>
                    Meta
                <% end %>
              </div>
            </div>
          <% end %>
        </div>
        
    <!-- Step 1 Content -->
        <%= if @current_step == 1 do %>
          <div class="space-y-4">
            <.input field={@form[:name]} label="Product Name" required />
            <.input field={@form[:product_description]} label="Description" type="textarea" required />

            <div class="flex justify-end">
              <.button type="button" phx-click="next_step" class="bg-blue-600 hover:bg-blue-700">
                Next →
              </.button>
            </div>
          </div>
        <% end %>
        
    <!-- Step 2 Content -->
        <%= if @current_step == 2 do %>
          <.inputs_for :let={pi} field={@form[:product_info]}>
            <div class="grid grid-cols-2 gap-4">
              <.input field={pi[:manufacturer]} label="Manufacturer" required />
              <.input field={pi[:brand]} label="Brand" required />
              <.input field={pi[:price]} label="Price" type="number" step="0.01" required />
              <.input field={pi[:discount]} label="Discount" type="number" step="0.01" required />
              <.input field={pi[:stocks]} label="Stocks" type="number" required />
              <.input field={pi[:orders]} label="Orders" type="number" required />
            </div>

            <div class="flex justify-between mt-6">
              <.button type="button" phx-click="prev_step" class="bg-gray-500 hover:bg-gray-600">
                ← Previous
              </.button>
              <.button type="button" phx-click="next_step" class="bg-blue-600 hover:bg-blue-700">
                Next →
              </.button>
            </div>
          </.inputs_for>
        <% end %>
        
    <!-- Step 3 Content -->
        <%= if @current_step == 3 do %>
          <.inputs_for :let={pm} field={@form[:product_meta]}>
            <div class="space-y-4">
              <.input field={pm[:title]} label="Meta Title" required />
              <.input field={pm[:keywords]} label="Meta Keywords" required />
              <.input field={pm[:description]} label="Meta Description" type="textarea" required />
            </div>

            <div class="flex justify-between mt-6">
              <.button type="button" phx-click="prev_step" class="bg-gray-500 hover:bg-gray-600">
                ← Previous
              </.button>
              <.button type="submit" class="bg-green-600 hover:bg-green-700">
                Create Product
              </.button>
            </div>
          </.inputs_for>
        <% end %>
      </.form>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    # Initialize with proper embedded structs
    current_user = socket.assigns.current_user

    product = %Product{
      product_info: %ProductInfo{},
      product_meta: %ProductMeta{}
    }

    {:ok,
     socket
     |> assign(:product, product)
     |> assign(:form_data, %{})
     |> assign(:form, to_form(Product.changeset(product, %{}, current_user)))
     |> assign(:current_step, 1)}
  end

  @impl true
  def handle_event("validate", %{"product" => params}, socket) do
    # Merge new params with existing form data
    form_data = Map.merge(socket.assigns.form_data, params)

    changeset =
      socket.assigns.product
      |> Product.changeset(form_data)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:form_data, form_data)
     |> assign(:form, to_form(changeset))}
  end

  def handle_event("next_step", _, socket) do
    # Validate current step before proceeding
    changeset = Product.changeset(socket.assigns.product, socket.assigns.form_data)

    if changeset.valid? do
      {:noreply, assign(socket, :current_step, socket.assigns.current_step + 1)}
    else
      {:noreply, assign(socket, :form, to_form(Map.put(changeset, :action, :validate)))}
    end
  end

  def handle_event("prev_step", _, socket) do
    {:noreply, assign(socket, :current_step, max(socket.assigns.current_step - 1, 1))}
  end

  def handle_event("submit", %{"product" => params}, socket) do
    case Products.create_product(params, socket.assigns.current_user) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully!")
         |> push_navigate(to: ~p"/")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  # defp determine_error_step(changeset) do
  #   cond do
  #     changeset.errors[:name] || changeset.errors[:product_description] -> 1
  #     changeset.errors[:product_info] -> 2
  #     changeset.errors[:product_meta] -> 3
  #     true -> 1
  #   end
  # end

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
