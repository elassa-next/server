defmodule ServerWeb.V1.Admin.Accounts.Permissions.RoleJSON do
  alias Accounts.Schema.Permission.Permission
  alias Accounts.Schema.Permission.Role

  @doc """
  Renders a list of roles.
  """
  def index(%{roles: roles}) do
    %{data: for(role <- roles, do: data(role))}
  end

  @doc """
  Renders a single role.
  """
  def show(%{role: role}) do
    %{data: data(role)}
  end

  defp data(%Role{} = role) do
    %{
      id: role.id,
      name: role.name,
      scope: role.scope,
      permissions: for(p <- safe_permissions(role), do: permissions_data(p))
    }
  end

  defp safe_permissions(%{permissions: p}) when is_list(p), do: p
  defp safe_permissions(_), do: []

  defp permissions_data(%Permission{} = permission) do
    %{
      id: permission.id,
      name: permission.name
    }
  end
end
