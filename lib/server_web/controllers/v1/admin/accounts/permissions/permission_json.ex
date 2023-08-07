defmodule ServerWeb.V1.Admin.Accounts.Permissions.PermissionJSON do
  alias Accounts.Schema.Permission.Permission

  @doc """
  Renders a list of permissions.
  """
  def index(%{permissions: permissions}) do
    %{data: for(permission <- permissions, do: data(permission))}
  end

  defp data(%Permission{} = permission) do
    %{
      id: permission.id,
      name: permission.name
    }
  end
end
