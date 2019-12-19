defmodule DemoWeb.AssignsTitleComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <h1><%= @title %></h1>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def update(%{title: title} = _assigns, socket) do
    {:ok, assign(socket, title: title)}
  end
end
