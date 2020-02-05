defmodule DemoWeb.StatefulSendSelfComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  def render(assigns) do
    ~L"""
    <h2><%= @title %></h2>
    <div id="<%= @id %>">
    <%= f = form_for :heading, "#", [phx_submit: :set_title, "phx-target": "##{@id}"] %>
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
    send(
      self(),
      {__MODULE__, :updated_title, %{title: updated_title}}
    )

    {:noreply, socket}
  end
end
