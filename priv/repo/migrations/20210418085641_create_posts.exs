defmodule Tweets.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :body, :text, null: false

      timestamps()
    end

  end
end
