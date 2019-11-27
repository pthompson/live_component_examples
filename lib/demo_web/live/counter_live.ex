defmodule DemoWeb.CounterLive do
  use DemoWeb, :live_view

  def render(assigns) do
    ~L"""
    <%= if not @confirm_reset do %>
    <div>
      <h1>The count is: <span><%= @val %></span></h1>
      <button phx-click="reset" class="alert-danger">RESET</button>
      <button phx-click="dec">-</button>
      <button phx-click="inc">+</button>
    </div>
    <% else %>
    <h1>CONFIRM RESET</h1>
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

    {:noreply, assign(socket, confirm_reset: false)}
  end

  def handle_params(_params, _uri, "confirm-reset", socket) do
    IO.puts("IN HANDLE PARAMS, confirm-reset")

    {:noreply, assign(socket, confirm_reset: true)}
  end

  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

  def handle_event("reset", _, socket) do
    {:noreply,
     live_redirect(
       socket
       |> assign(confirm_reset: true),
       to: Routes.confirm_reset_live_path(socket, DemoWeb.CounterLive),
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
    |> List.last()
  end
end
