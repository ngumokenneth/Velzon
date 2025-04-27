defmodule VelzonWeb.ProductLive.Index do
  use VelzonWeb, :live_view

  def render(assigns) do
    ~H"""
    created products are listed here
    """
  end

  def mount(__params, _session, socket) do
    {:ok, socket}
  end
end
