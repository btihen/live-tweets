defmodule TweetsWeb.PageLiveTest do
  use TweetsWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Listing Posts"
    assert render(page_live) =~ "Listing Posts"
  end
end
