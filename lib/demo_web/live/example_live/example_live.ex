defmodule DemoWeb.LiveComponentExamples do
  use DemoWeb, :live_view

  def render(assigns) do
    ~L"""
    <section class="row">
      <article class="column">
        <h4>Simple LiveComponent Examples</h4>
        <ul>
          <li><%= live_patch("Static Title Example", to: Routes.live_path(@socket, DemoWeb.StaticTitleLiveView)) %></li>
          <li><%= live_patch("Assigns Title Example", to: Routes.live_path(@socket, DemoWeb.AssignsTitleLiveView)) %></li>
          <li><%= live_patch("Stateless Component Example", to: Routes.live_path(@socket, DemoWeb.StatelessComponentLiveView)) %></li>
          <li><%= live_patch("Stateful Component Example", to: Routes.live_path(@socket, DemoWeb.StatefulComponentLiveView)) %></li>
          <li><%= live_patch("Stateful Send Self Component Example", to: Routes.live_path(@socket, DemoWeb.StatefulSendSelfComponentLiveView)) %></li>
          <li><%= live_patch("Stateful Preload Component Example", to: Routes.live_path(@socket, DemoWeb.StatefulPreloadComponentLiveView)) %></li>
          <li><%= live_patch("Component Blocks Example", to: Routes.live_path(@socket, DemoWeb.ComponentBlocksLiveView)) %></li>
        </ul>
      </article>
    </section>
    """
  end

  def mount(_session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
