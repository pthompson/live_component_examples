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
    background_color: "bg-smoke-700",
    title_color: "sunset-orange-600",
    single_button: "OK",
    single_button_color: "sunset-orange-600",
    single_button_hover_color: "sunset-orange-500",
    single_button_action: nil,
    single_button_param: nil,
    left_button: "Cancel",
    left_button_color: "sunset-orange-400",
    left_button_hover_color: "sunset-orange-300",
    left_button_action: nil,
    left_button_param: nil,
    right_button: "OK",
    right_button_color: "sunset-orange-600",
    right_button_hover_color: "sunset-orange-500",
    right_button_action: nil,
    right_button_param: nil
  }

  # render modal
  @spec render(map()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <div>
      <!-- Modal Background -->
      <div class="fixed top-0 left-0 w-full h-full <%= @background_color %> z-40"></div>

      <!-- Modal Container -->
      <div class="animated fadeIn fixed inset-0 overflow-y-auto flex items-center justify-center z-50"
           phx-hook="ScrollLock">
        <!-- Modal Inner Container -->
        <div class="h-auto relative border-0 w-68
                    sm:w-72">
          <!-- Modal Card -->
          <div class="flex flex-col items-center min-w-full min-h-full bg-white">
            <div class="pt-4 pb-5 px-6
                        sm:px-7">
              <!-- Title -->
              <%= if @title != nil do %>
              <div class="uppercase text-center font-semibold text-sm tracking-widest text-<%= @title_color %>">
                <%= @title %>
              </div>
              <% end %>
              <!-- Body -->
              <%= if @body != nil do %>
              <div class="<%= if @title != nil, do: "mt-2" %> text-center text-base">
                <%= @body %>
              </div>
              <% end %>
            </div>
            <!-- Buttons -->
            <div class="h-12 min-w-full">
              <div class="h-12 flex items-center h-2 min-w-full text-center text-white">
                <%= if @single_button_action != nil do %>

                <!-- Single Button -->
                <button class="flex flex-col justify-center h-12 min-w-full bg-<%= @single_button_color %> text-center font-semibold text-xs tracking-widest uppercase
                               hover:bg-<%= @single_button_hover_color %>
                               focus:outline-none focus:bg-<%= @single_button_color %>"
                        type="button"
                        phx-click="single-button-click">
                  <div>
                    <%= @single_button %>
                  </div>
                </button>

                <% else %>

                <!-- Left Button -->
                <button class="flex flex-col justify-center h-12 w-1/2 bg-<%= @left_button_color %> text-center font-semibold text-xs tracking-widest uppercase
                               hover:bg-<%= @left_button_hover_color %>
                               focus:outline-none focus:bg-<%= @left_button_color %>"
                        type="button"
                        phx-click="left-button-click">
                  <div>
                    <%= @left_button %>
                  </div>
                </button>
                <!-- Right Button -->
                <button class="flex flex-col justify-center h-12 w-1/2 bg-<%= @right_button_color %> text-center font-semibold text-xs tracking-widest
                               hover:bg-<%= @right_button_hover_color %>
                               focus:outline-none focus:bg-<%= @right_button_color %>"
                        type="button"
                        phx-click="right-button-click">
                  <div>
                    <%= @right_button %>
                  </div>
                </button>

                <% end %>
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

  # Fired when user clicks single button on modal
  def handle_event(
        "single-button-click",
        _params,
        %{
          assigns: %{
            single_button_action: single_button_action,
            single_button_param: single_button_param
          }
        } = socket
      ) do
    send(
      self(),
      {__MODULE__, :button_pressed, %{action: single_button_action, param: single_button_param}}
    )

    {:noreply, socket}
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
