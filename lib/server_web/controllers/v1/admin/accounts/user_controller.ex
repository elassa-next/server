defmodule ServerWeb.V1.Admin.Accounts.UserController do
  use ServerWeb, :controller

  alias Accounts.Context.Users
  alias Accounts.Schema.User

  action_fallback ServerWeb.FallbackController

  plug Bodyguard.Plug.Authorize, policy: Accounts.Policy.UserPolicy

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/v1/admin/accounts/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def assign(conn, %{"id" => id, "user" => %{"scope" => scope, "role_ids" => role_ids}}) do
    with {:ok, %User{} = user} <- Users.find_user(%{id: id}, scope, true),
         {:ok, %User{} = user} <- Users.assign_roles(user, scope, role_ids) do
      render(conn, :show, user: user)
    end
  end
end
