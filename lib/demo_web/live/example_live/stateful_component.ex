defmodule DemoWeb.StatefulComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  def render(assigns) do
    ~L"""
    <h2><%= @title %></h2>
    <div id="stateful-<%= @id %>">
    <%= f = form_for :heading, "#", [phx_submit: :set_title, "phx-target": "#stateful-#{@id}"]  %>
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

  def update(%{title: title, id: id}, socket) do
    {:ok,
     assign(socket,
       title: title,
       id: id
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
