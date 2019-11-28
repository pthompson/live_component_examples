defmodule DemoWeb.CounterLive do
  use DemoWeb, :live_view
  alias DemoWeb.LiveComponent.ModalLive

  def render(assigns) do
    ~L"""
    <div>
      <h1>The count is: <span><%= @val %></span></h1>
      <button class="alert-danger"
              phx-click="boom">Boom</button>
      <button phx-click="dec">-</button>
      <button phx-click="inc">+</button>
    </div>
    <%= if @prepare_to_crash do %>
      <%= live_component(@socket,
                         ModalLive,
                         id: "confirm-boom",
                         title: "Go Boom?",
                         body: "Are you sure you want to crash the counter?",
                         right_button: "OK",
                         right_button_action: "crash",
                         right_button_param: "boom",
                         left_button: "Cancel",
                         left_button_action: "cancel-boom",
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
    {:noreply, assign(socket, prepare_to_crash: false)}
  end

  def handle_params(_params, _uri, "confirm-boom", %{assigns: %{prepare_to_crash: _}} = socket) do
    {:noreply, assign(socket, prepare_to_crash: true)}
  end

  def handle_params(_params, _uri, "confirm-boom", socket) do
    # Redirect to base counter path if prepare_to_crash not set, indicating that
    # the counter hasn't been initialized which can happen if counter crashes or
    # user comes in on counter/confirm-boom uri without going through /counter first
    # (e.g., if they used a saved URL).
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

  def handle_event("boom", _, socket) do
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
        {ModalLive, :button_pressed, %{action: "cancel-boom", param: nil}},
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
