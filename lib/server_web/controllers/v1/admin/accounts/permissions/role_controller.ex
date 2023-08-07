defmodule ServerWeb.V1.Admin.Accounts.Permissions.RoleController do
  use ServerWeb, :controller

  alias Accounts.Context.Permissions.Roles
  alias Accounts.Schema.Permission.Role

  action_fallback ServerWeb.FallbackController

  plug Bodyguard.Plug.Authorize, policy: Accounts.Policy.Permission.RolePolicy

  def index(conn, _params) do
    roles = Roles.list_roles()
    render(conn, :index, roles: roles)
  end

  def create(conn, %{"role" => role_params}) do
    with {:ok, %Role{} = role} <- Roles.create_role(role_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/v1/admin/accounts/roles/#{role}")
      |> render(:show, role: role)
    end
  end

  def show(conn, %{"id" => id}) do
    role = Roles.get_role_with_permissions!(id)
    render(conn, :show, role: role)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = Roles.get_role!(id)

    with {:ok, %Role{} = role} <-
           Roles.update_role(role, role_params) do
      render(conn, :show, role: role)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = Roles.get_role!(id)

    with {:ok, %Role{}} <- Roles.delete_role(role) do
      send_resp(conn, :no_content, "")
    end
  end

  def assign(conn, %{"id" => id, "role" => %{"permission_ids" => permission_ids}}) do
    role = Roles.get_role!(id)

    with {:ok, %Role{} = role} <- Roles.assign_permissions(role, permission_ids) do
      render(conn, :show, role: role)
    end
  end
end
