defmodule DemoWeb.StatefulSendSelfComponentLiveView do
  use DemoWeb, :live_view

  def render(assigns) do
    ~L"""
    <div>
    <%= live_component(
          @socket,
          DemoWeb.StatefulSendSelfComponent,
          id: "stateful-send-self-component",
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

  def handle_info(
        {DemoWeb.StatefulSendSelfComponent, :updated_title, %{title: updated_title}},
        socket
      ) do
    {:noreply, assign(socket, title: updated_title)}
  end
end
