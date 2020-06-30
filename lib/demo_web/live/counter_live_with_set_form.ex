defmodule DemoWeb.CounterLiveWithSetForm do
  use DemoWeb, :live_view
  alias DemoWeb.LiveComponent.ModalBackgroundLive

  def render(assigns) do
    ~L"""
    <div>
      <h1>The count is: <span><%= @val %></span></h1>
      <button phx-click="set">Set</button>
      <button phx-click="dec">-</button>
      <button phx-click="inc">+</button>
    </div>
    <%= if @show_modal do %>
      <%= render_modal_form(assigns, title: "Set Counter", value: @val) %>
    <% end %>
    """
  end

  def render_modal_form(assigns, title: title, value: value) do
    ~L"""
    <%= live_component @socket,
                        ModalBackgroundLive,
                        title: title,
                        value: value do %>
      <div class="modal-card">
        <div class="modal-inner-card">
          <!-- Title -->
          <%= if @title != nil do %>
          <div class="modal-form-title">
            <%= @title %>
          </div>
          <% end %>
          <div>
          <%= f = form_for :counter, "#", [phx_submit: :set_counter] %>
            <%= label f, :count %>
            <%= number_input f, :count, value: @value %>
            <div>
              <%= submit "Set", phx_disable_with: "Setting..." %>
            </div>
          </form>
        </div>
      </div>
    <% end %>
    """
  end

  def mount(_params, session, socket) do
    {:ok, assign(socket, val: session[:val] || 0)}
  end

  def handle_params(params, uri, socket),
    do: handle_params(params, uri, last_path_segment(uri), socket)

  def handle_params(_params, _uri, "counter-with-set", socket) do
    {:noreply, assign(socket, show_modal: false)}
  end

  def handle_params(
        _params,
        _uri,
        "set-counter",
        %{assigns: %{show_modal: _}} = socket
      ) do
    {:noreply, assign(socket, show_modal: true)}
  end

  def handle_params(_params, _uri, _last_path_segment, socket) do
    {:noreply,
     push_redirect(socket,
       to: Routes.live_path(socket, DemoWeb.CounterLiveWithSetForm),
       replace: true
     )}
  end

  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

  def handle_event("set", _, socket) do
    {:noreply,
     push_redirect(
       socket,
       to: Routes.set_counter_live_path(socket, DemoWeb.CounterLiveWithSetForm),
       replace: false
     )}
  end

  def handle_event(
        "set_counter",
        %{"counter" => %{"count" => count}},
        socket
      ) do
    {:noreply,
     push_redirect(assign(socket, val: String.to_integer(count)),
       to: Routes.live_path(socket, DemoWeb.CounterLiveWithSetForm),
       replace: true
     )}
  end

  defp last_path_segment(uri) do
    uri
    |> URI.parse()
    |> Map.get(:path)
    |> String.split("/", trim: true)
    |> List.last()
  end
end
