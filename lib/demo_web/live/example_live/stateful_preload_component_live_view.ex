defmodule DemoWeb.StatefulPreloadComponentLiveView do
  use DemoWeb, :live_view

  def render(assigns) do
    ~L"""
    <div>
    <%= live_component(
          @socket,
          DemoWeb.StatefulPreloadComponent,
          id: "1",
          title: @title
        )
    %>
    </div>
    <div>
    <%= live_component(
          @socket,
          DemoWeb.StatefulPreloadComponent,
          id: "2",
          title: @title
        )
    %>
    </div>
    <div>
    <%= live_component(
          @socket,
          DemoWeb.StatefulPreloadComponent,
          id: "3",
          title: @title
        )
    %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       title: "Initial Title"
     )}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
