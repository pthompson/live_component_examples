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
                         title: "Go Boom",
                         body: "Are you sure you want to crash the counter?",
                         right_button: "Sure",
                         right_button_action: "crash",
                         right_button_param: "boom",
                         left_button: "Yikes, No!",
                         left_button_action: "cancel-crash")
      %>
    <% end %>
    """
  end

  def mount(_params, session, socket) do
    {:ok, assign(socket, val: session[:val] || 0)}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :show, _params) do
    assign(socket, show_modal: false)
  end

  def apply_action(%{assigns: %{show_modal: _}} = socket, :confirm_boom, _params) do
    assign(socket, show_modal: true)
  end

  def apply_action(socket, _live_action, _params) do
    # Redirect to base counter path if live_action is unknown or if
    # show_modal not set, which indicates that the counter hasn't been
    # initialized. This can happen when user comes in on
    # /counter/confirm-boom uri without going through /counter first
    # or if the counter crashed while on the /counter/confirm-boom URL.
    push_patch(socket,
      to: Routes.counter_path(socket, :show),
      replace: true
    )
  end

  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

  def handle_event("go-boom", _, socket) do
    {:noreply,
     push_patch(
       assign(socket, show_modal: true),
       to: Routes.counter_path(socket, :confirm_boom),
       replace: true
     )}
  end

  # Handle message to self() from Confirm Boom modal
  def handle_info(
        {ModalLive, :button_clicked, %{action: "crash", param: exception}},
        socket
      ) do
    raise(exception)
    {:noreply, socket}
  end

  # Handle message to self() from Confirm Boom modal
  def handle_info(
        {ModalLive, :button_clicked, %{action: "cancel-crash"}},
        socket
      ) do
    {:noreply,
     push_redirect(socket,
       to: Routes.counter_path(socket, :show),
       replace: true
     )}
  end
end
