defmodule DemoWeb.Router do
  use DemoWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {DemoWeb.LayoutView, :app}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DemoWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/counter", CounterLive

    live "/counter/set-count", CounterLive,
      session: [:val],
      as: "set_count_live"

    live "/examples", LiveComponentExamples

    live "/examples/static-title", StaticTitleLiveView

    live "/examples/assigns-title", AssignsTitleLiveView

    live "/examples/stateless-component", StatelessComponentLiveView

    live "/examples/stateful-component", StatefulComponentLiveView

    live "/examples/stateful-send-self-component", StatefulSendSelfComponentLiveView

    live "/examples/stateful-preload-component", StatefulPreloadComponentLiveView

    live "/examples/component-blocks", ComponentBlocksLiveView
  end
end
