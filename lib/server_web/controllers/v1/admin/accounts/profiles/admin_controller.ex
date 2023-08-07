defmodule ServerWeb.V1.Admin.Accounts.Profiles.AdminController do
  use ServerWeb, :controller

  alias Accounts.Context.Profiles.Admins
  alias Accounts.Schema.Profile.Admin

  action_fallback ServerWeb.FallbackController

  plug Bodyguard.Plug.Authorize, policy: Accounts.Policy.Profile.AdminPolicy

  def index(conn, _params) do
    admins = Admins.list_admins()
    render(conn, :index, admins: admins)
  end

  def create(conn, %{"admin" => admin_params}) do
    with {:ok, %Admin{} = admin} <- Admins.create_admin(admin_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/v1/admin/accounts/admins/#{admin}")
      |> render(:show, admin: admin)
    end
  end

  def show(conn, %{"id" => id}) do
    admin = Admins.get_full_admin!(id)
    render(conn, :show, admin: admin)
  end

  def update(conn, %{"id" => id, "admin" => admin_params}) do
    admin = Admins.get_admin!(id)

    with {:ok, %Admin{} = admin} <- Admins.update_admin(admin, admin_params) do
      render(conn, :show, admin: admin)
    end
  end

  def delete(conn, %{"id" => id}) do
    admin = Admins.get_admin!(id)

    with {:ok, _} <- Admins.delete_admin(admin) do
      send_resp(conn, :no_content, "")
    end
  end
end
