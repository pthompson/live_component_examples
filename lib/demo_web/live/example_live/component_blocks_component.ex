defmodule DemoWeb.ComponentBlocksComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  def render(assigns) do
    ~L"""
    <%= @render_title.(title_passed_from_component: @title) %>
    """
  end

  def mount(_session, socket) do
    {:ok, socket}
  end

  def update(%{title: title, inner_content: inner_content}, socket) do
    {:ok,
     assign(socket,
       title: title,
       render_title: inner_content
     )}
  end
end
