defmodule ServerWeb.V1.Admin.Accounts.UserJSON do
  alias Accounts.Schema.Permission.Role
  alias Accounts.Schema.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      name: user.name,
      email: user.email,
      phone: user.phone,
      image: user.image,
      confirmed_at: user.confirmed_at,
      active: user.active,
      roles: for(r <- safe_roles(user), do: roles_data(r))
    }
  end

  defp safe_roles(%{roles: r}) when is_list(r), do: r
  defp safe_roles(_), do: []

  defp roles_data(%Role{} = role) do
    %{
      id: role.id,
      name: role.name
    }
  end
end
