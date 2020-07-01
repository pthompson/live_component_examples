defmodule DemoWeb.Router do
  use DemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DemoWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DemoWeb do
    pipe_through :browser

    live "/", PageLive, :index

    live "/counter", CounterLive, :show

    live "/counter/confirm-boom", CounterLive, :confirm_boom

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
