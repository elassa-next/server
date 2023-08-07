defmodule ServerWeb.V1.Admin.Accounts.Permissions.PermissionController do
  use ServerWeb, :controller

  alias Accounts.Context.Permissions.Permissions

  action_fallback ServerWeb.FallbackController

  plug Bodyguard.Plug.Authorize, policy: Accounts.Policy.Permission.PermissionPolicy

  def index(conn, _params) do
    permissions = Permissions.list_permissions()
    render(conn, :index, permissions: permissions)
  end
end
