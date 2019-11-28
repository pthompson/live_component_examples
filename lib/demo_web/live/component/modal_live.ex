defmodule DemoWeb.LiveComponent.ModalLive do
  @moduledoc """
  This is a general modal component with a title, body text, and either
  one or two buttons. Many aspects of the modal can be customized, including
  colors, button labels, and title and body text. Application wide defaults
  are specified for the colors and button texts.

  A required action string and optional parameter are provided for each
  button when the modal is initialized. These will be returned to the caller
  when the corresponding button is clicked.

  The caller must have message handlers defined for each button that takes
  the given action and parameter for each button. For example:

    def handle_info(
      {ModalLive, :button_pressed, %{action: "remove-book", param: book_id_string}},
      socket
    )

  This is a stateful component, so you MUST specify an id when calling
  live_component.

  The component can be called like:

  <div id="confirm-book-removal">
    <%= Phoenix.LiveView.live_component(@socket,
                                        BooklistiWeb.LiveComponent.ModalLive,
                                        id: "confirm-book-removal",
                                        title: "Remove Book",
                                        body: "Are you sure you want to remove the book?",
                                        right_button: "OK",
                                        right_button_action: "remove-book",
                                        right_button_param: @remove_book_id,
                                        left_button: "Cancel",
                                        left_button_action: "cancel-remove-book"
                                        )
    %>
  </div>
  """

  use DemoWeb, :live_component

  @defaults %{
    left_button: "Cancel",
    left_button_action: nil,
    left_button_param: nil,
    right_button: "OK",
    right_button_action: nil,
    right_button_param: nil
  }

  # render modal
  @spec render(map()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <div>
      <!-- Modal Background -->
      <div class="modal-container"
         phx-hook="ScrollLock">
        <div class="modal-inner-container">
          <div class="modal-card">
            <div class="modal-inner-card">
              <!-- Title -->
              <%= if @title != nil do %>
              <div class="modal-title">
                <%= @title %>
              </div>
              <% end %>

              <!-- Body -->
              <%= if @body != nil do %>
              <div class="modal-body">
                <%= @body %>
              </div>
              <% end %>

              <!-- Buttons -->
              <div class="flex modal-buttons">
                <!-- Left Button -->
                <button class="left-button"
                        type="button"
                        phx-click="left-button-click">
                  <div>
                    <%= @left_button %>
                  </div>
                </button>
                <!-- Right Button -->
                <button class="right-button"
                        type="button"
                        phx-click="right-button-click">
                  <div>
                    <%= @right_button %>
                  </div>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @spec mount(map, Phoenix.LiveView.Socket.t()) :: {:ok, Phoenix.LiveView.Socket.t()}
  def mount(_session, socket) do
    {:ok, socket}
  end

  @spec update(map, Phoenix.LiveView.Socket.t()) :: {:ok, Phoenix.LiveView.Socket.t()}
  def update(assigns, socket) do
    {:ok, assign(socket, Map.merge(assigns, @defaults, fn _k, v1, _v2 -> v1 end))}
  end

  # Fired when user clicks right button on modal
  def handle_event(
        "right-button-click",
        _params,
        %{
          assigns: %{
            right_button_action: right_button_action,
            right_button_param: right_button_param
          }
        } = socket
      ) do
    send(
      self(),
      {__MODULE__, :button_pressed, %{action: right_button_action, param: right_button_param}}
    )

    {:noreply, socket}
  end

  def handle_event(
        "left-button-click",
        _params,
        %{
          assigns: %{
            left_button_action: left_button_action,
            left_button_param: left_button_param
          }
        } = socket
      ) do
    send(
      self(),
      {__MODULE__, :button_pressed, %{action: left_button_action, param: left_button_param}}
    )

    {:noreply, socket}
  end
end
