defmodule DemoWeb.CounterLive do
  use DemoWeb, :live_view
  alias DemoWeb.LiveComponent.ModalLive

  def render(assigns) do
    ~L"""
    <div>
      <h1>The count is: <span><%= @val %></span></h1>
      <button class="alert-danger"
              phx-click="go-boom">Boom</button>
      <button phx-click="dec">-</button>
      <button phx-click="inc">+</button>
    </div>
    <%= if @show_modal do %>
      <%= live_component(@socket,
                         ModalLive,
                         id: "confirm-boom",
                         title: "Go Boom?",
                         body: "Are you sure you want to crash the counter?",
                         right_button: "OK",
                         right_button_action: "crash",
                         right_button_param: "boom",
                         left_button: "Cancel",
                         left_button_action: "cancel-crash",
                         left_button_param: nil)
      %>
    <% end %>
    """
  end

  def mount(session, socket) do
    {:ok, assign(socket, val: session[:val] || 0)}
  end

  def handle_params(params, uri, socket),
    do: handle_params(params, uri, last_path_segment(uri), socket)

  def handle_params(_params, _uri, "counter", socket) do
    {:noreply, assign(socket, show_modal: false)}
  end

  def handle_params(_params, _uri, "confirm-boom", %{assigns: %{show_modal: _}} = socket) do
    {:noreply, assign(socket, show_modal: true)}
  end

  def handle_params(_params, _uri, "confirm-boom", socket) do
    # Redirect to base counter path if show_modal not set, which indicates that
    # the counter hasn't been initialized. This can happen user comes in on
    #  /counter/confirm-boom uri without going through /counter first
    # or if the counter crashed while on the confirm-boom URL.
    {:noreply,
     live_redirect(socket,
       to: Routes.live_path(socket, DemoWeb.CounterLive),
       replace: true
     )}
  end

  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

  def handle_event("go-boom", _, socket) do
    {:noreply,
     live_redirect(
       socket,
       to: Routes.confirm_boom_live_path(socket, DemoWeb.CounterLive),
       replace: false
     )}
  end

  # Handle message to self() from Confirm Boom modal
  def handle_info(
        {ModalLive, :button_pressed, %{action: "crash", param: exception}},
        socket
      ) do
    raise(exception)
    {:noreply, socket}
  end

  # Handle message to self() from Confirm Boom modal
  def handle_info(
        {ModalLive, :button_pressed, %{action: "cancel-crash"}},
        socket
      ) do
    {:noreply,
     live_redirect(socket,
       to: Routes.live_path(socket, DemoWeb.CounterLive),
       replace: false
     )}
  end

  defp last_path_segment(uri) do
    uri
    |> URI.parse()
    |> Map.get(:path)
    |> String.split("/")
    |> Enum.reject(&(&1 == ""))
    |> List.last()
  end
end
