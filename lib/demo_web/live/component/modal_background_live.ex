defmodule DemoWeb.LiveComponent.ModalBackgroundLive do
  @moduledoc """
  This is a general component to render a background to a modal view. The modal view is passed in as a block that will be rendered in the foreground of a semi-transparent background.

  It will be rendered in front of any content already rendered
  on the page.

  It could be called like this.

    <%= live_component @socket,
                       ModalBackgroundLive,
                       title: title do %>
      <div class="modal-card">
        <div class="modal-inner-card">
          <!-- Title -->
          <%= if @title != nil do %>
          <div class="modal-title">
            <%= @title %>
          </div>
          <% end %>
        </div>
      </div>
    <% end %>

  live_component assigns will be available to the block at render time.
  """
  use Phoenix.LiveComponent

  # render modal
  @spec render(map()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <div>
      <!-- Modal Background -->
      <div class="modal-container"
          phx-hook="ScrollLock">
        <div class="modal-inner-container">
          <%= @inner_content.(assigns) %>
        </div>
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def update(%{inner_content: _inner_content} = assigns, socket) do
    {:ok, assign(socket, Map.merge(socket.assigns, assigns))}
  end
end
