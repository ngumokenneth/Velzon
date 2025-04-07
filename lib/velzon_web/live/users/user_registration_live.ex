defmodule VelzonWeb.Users.UserRegistrationLive do
  use VelzonWeb, :live_view

  alias Velzon.Accounts
  alias Velzon.Accounts.User

  def render(assigns) do
    ~H"""
    <.header>
      <p class="text-headings">Register Account</p>
      <:subtitle>
        Get your free Velzon account now
      </:subtitle>
    </.header>
    <.simple_form id="registration-form" for={@form} phx-change="validate" phx-submit="submit">
      <.input label="Email" placeholder="Enter email address" field={@form[:email]} />
      <.input label="Username" placeholder="Enter your username" field={@form[:username]} />
      <.input label="Password" placeholder="Enter your password" field={@form[:password]} />
      <p class="text-sm text-primary  italic ">
        By registering you agree to the Velzon
        <span class="font-semibold non-italic text-headings">Terms of Use</span>
      </p>
      <.button class="bg-secondary w-full font-medium">
        Sign Up
      </.button>
    </.simple_form>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, prepare_socket(socket)}
  end

  def handle_event("validate", %{"registration_form" => params}, socket) do
    {:noreply, handle_validate(params, socket)}
  end

  def handle_event("submit", %{"registration_form" => params}, socket) do
    {:noreply, handle_submit(params, socket)}
  end

  defp handle_submit(params, socket) do
    case Accounts.create_user(params) do
      {:ok, _user} ->
        socket |> put_flash(:info, "User Created succcessfully") |> push_navigate(to: ~p"/")

      {:error, Ecto.Changeset = changeset} ->
        socket
        |> put_flash(:info, "Error creating a user")
        |> assign(:changeset, changeset)
    end
  end

  defp handle_validate(params, socket) do
    changeset = Accounts.change_user(%User{}, params)
    form = to_form(%{changeset | action: :validate}, as: "registration_form")
    assign(socket, :form, form)
  end

  defp prepare_socket(socket) do
    changeset = Accounts.change_user()
    form = to_form(changeset, as: "registration_form")
    assign(socket, :form, form)
  end
end
