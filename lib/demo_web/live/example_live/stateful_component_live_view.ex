defmodule DemoWeb.StatefulComponentLiveView do
  use DemoWeb, :live_view

  def render(assigns) do
    ~L"""
    <div>
    <%= live_component(
          @socket,
          DemoWeb.StatefulComponent,
          id: "1",
          title: @title
        )
    %>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok,
     assign(socket,
       title: "Initial Title"
     )}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
