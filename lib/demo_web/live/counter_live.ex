defmodule DemoWeb.CounterLive do
  use DemoWeb, :live_view

  def render(assigns) do
    ~L"""
    <div>
      <h1>The count is: <span><%= @val %></span></h1>
      <button phx-click="set">Set</button>
      <button phx-click="dec">-</button>
      <button phx-click="inc">+</button>
    </div>
    <%= if @set_count do %>
    <div>
      <div class="modal-container">
        <div class="modal-inner-container">
          <div class="modal-card">
          <div class="modal-form">
            <%= f = form_for :counter, "#", [phx_submit: :set_count] %>
              <%= label f, "Set Count" %>
              <%= number_input f, :count %>
              <div>
                <%= submit "Set", phx_disable_with: "Setting..." %>
              </div>
            </form>
            </div>
          </div>
        </div>
      </div>
    </div>
    <% end %>
    """
  end

  def mount(session, socket) do
    {:ok, assign(socket, val: session[:val] || 0)}
  end

  def handle_params(params, uri, socket),
    do: handle_params(params, uri, last_path_segment(uri), socket)

  def handle_params(_params, _uri, "counter", socket) do
    IO.puts("IN HANDLE PARAMS, counter")

    {:noreply, assign(socket, set_count: false)}
  end

  def handle_params(_params, _uri, "set-count", socket) do
    IO.puts("IN HANDLE PARAMS, set-count")

    {:noreply, assign(socket, set_count: true)}
  end

  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

  def handle_event("set", _, socket) do
    {:noreply,
     live_redirect(
       socket
       |> assign(set_count: true),
       to: Routes.set_count_live_path(socket, DemoWeb.CounterLive),
       replace: false
     )}
  end

  # Handle message to self() from Confirm Reset modal
  # def handle_info(
  #       {ModalLive, :button_pressed, %{action: "reset-counter", param: nil}},
  #       socket
  #     ) do
  #   book_id = String.to_integer(book_id_string)

  #   booklist_book =
  #     Enum.find(booklist_books, fn booklist_book ->
  #       booklist_book.book.id == book_id
  #     end)

  #   Booklists.delete_booklist_book(booklist_book)

  #   {:noreply,
  #    live_redirect(
  #      socket
  #      |> assign(
  #        display_mode: :edit_booklist_mode,
  #        remove_book_title: nil,
  #        remove_book_id: nil
  #      ),
  #      to: Routes.live_path(socket, BooklistLive.Edit, booklist),
  #      replace: false
  #    )}
  # end

  # # Handle message to self() from Confirm Reset modal
  # def handle_info(
  #       {ModalLive, :button_pressed, %{action: "cancel-reset-counter", param: nil}},
  #       socket
  #     ) do
  #   {:noreply,
  #    live_redirect(socket |> assign(display_mode: :edit_booklist_mode),
  #      to: Routes.live_path(socket, BooklistLive.Edit, booklist),
  #      replace: false
  #    )}
  # end

  defp last_path_segment(uri) do
    uri
    |> URI.parse()
    |> Map.get(:path)
    |> String.split("/")
    |> Enum.reject(&(&1 == ""))
    |> List.last()
  end
end
