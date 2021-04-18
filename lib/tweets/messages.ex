defmodule Tweets.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias Tweets.Repo
  alias Tweets.Messages.Post

  # Setup Broadcasting
  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(Tweets.PubSub, @topic)
  end

  def notify_subscribers({:ok, post}, event) do
    posts = list_posts()
    Phoenix.PubSub.broadcast(Tweets.PubSub, @topic, {__MODULE__, event, posts})
    {:ok, post}
  end

  def notify_subscribers({:error, post}, event) do
    posts = list_posts()
    Phoenix.PubSub.broadcast(Tweets.PubSub, @topic, {__MODULE__, event, posts})
    {:error, post}
  end
  # Setup Broadcasting

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    # Repo.all(Post)
    Post |> order_by(desc: :inserted_at) |> Repo.all
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    event = "posts-changed"
    {status, post} = %Post{}
                      |> Post.changeset(attrs)
                      |> Repo.insert()
    notify_subscribers({status, post}, event)
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    event = "posts-changed"
    {status, post} = post
                      |> Post.changeset(attrs)
                      |> Repo.update()
    notify_subscribers({status, post}, event)
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    event = "posts-changed"
    {status, post} = Repo.delete(post)
    notify_subscribers({status, post}, event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
