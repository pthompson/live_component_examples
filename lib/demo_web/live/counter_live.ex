defmodule DemoWeb.CounterLive do
  use Phoenix.LiveView
  alias DemoWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <%= if !@say_hello do %>
    <div>
      <h1 phx-click="boom">The count is: <span id="val" phx-hook="Count" phx-update="ignore"><%= @val %></a></h1>
      <%= @val %>
      <button phx-click="boom" class="alert-danger">BOOM</button>
      <button phx-click="dec">-</button>
      <button phx-click="inc" phx-debounce="1000">+</button>
      <button phx-click="hello">Hello</button>
    </div>
    <% else %>
    <div id="say-hello">
      <h1> Hello! </h1>
    </div>
    <% end %>
    """
  end

  def mount(session, socket) do
    {:ok, assign(socket, val: session[:val] || 0, say_hello: false)}
  end

  def handle_params(_params, uri, socket) do
    IO.inspect(uri, label: "IN HANDLE PARAMS, uri")

    {:noreply,
     socket
     |> assign(say_hello: String.ends_with?(uri, "say-hello"))}
  end

  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

  def handle_event("hello", _, socket) do
    {:noreply,
     live_redirect(
       socket
       |> assign(say_hello: true),
       to: Routes.say_hello_live_path(socket, DemoWeb.CounterLive),
       replace: false
     )}
  end
end
