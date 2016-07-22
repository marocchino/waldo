defmodule Waldo.PageController do
  use Waldo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
