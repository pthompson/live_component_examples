defmodule DemoWeb.StatelessComponentLiveView do
  use DemoWeb, :live_view

  def render(assigns) do
    ~L"""
    <div>
    <%= live_component(
          @socket,
          DemoWeb.StatelessComponent,
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

  def handle_event(
        "set_title",
        %{"heading" => %{"title" => updated_title}},
        socket
      ) do
    {:noreply, assign(socket, title: updated_title)}
  end
end
