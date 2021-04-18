defmodule TweetsWeb.PostLive.Index do
  use TweetsWeb, :live_view

  alias Tweets.Messages
  alias Tweets.Messages.Post

  @impl true
  def mount(_params, _session, socket) do
    # register with the channel if connection to LiveView
    if connected?(socket), do: Messages.subscribe()
    {:ok, assign(socket, :posts, list_posts())}
  end

  @impl true
  def handle_info({Messages, "posts-changed", posts}, socket) do
    socket = assign(socket, :posts, posts)
    {:noreply, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    # Tweets.Endpoint.subscribe("tweets")
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Messages.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Messages.get_post!(id)
    {:ok, _} = Messages.delete_post(post)

    {:noreply, assign(socket, :posts, list_posts())}
  end

  defp list_posts do
    Messages.list_posts()
  end
end
