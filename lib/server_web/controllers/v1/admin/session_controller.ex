defmodule ServerWeb.V1.Admin.SessionController do
  use ServerWeb, :controller

  import Accounts.Guardian.SessionHandler

  alias Accounts.Constants

  action_fallback ServerWeb.FallbackController

  def create(conn, params) do
    with {:ok, user, token} <- login(params, Constants.admin()) do
      conn
      |> put_status(:created)
      |> render(:create, user: user, token: token)
    end
  end
end
