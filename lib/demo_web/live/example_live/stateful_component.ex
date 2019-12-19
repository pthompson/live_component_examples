defmodule DemoWeb.StatefulComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  def render(assigns) do
    ~L"""
    <h2><%= @title %></h2>
    <div>
    <%= f = form_for :heading, "#", [phx_submit: :set_title] %>
      <%= label f, :title %>
      <%= text_input f, :title %>
      <div>
        <%= submit "Set", phx_disable_with: "Setting..." %>
      </div>
    </form>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def update(%{title: title}, socket) do
    {:ok,
     assign(socket,
       title: title
     )}
  end

  def handle_event(
        "set_title",
        %{"heading" => %{"title" => updated_title}},
        socket
      ) do
    {:noreply, assign(socket, title: updated_title)}
  end
end
