defmodule ServerWeb.V1.Admin.Accounts.Profiles.AdminJSON do
  alias Accounts.Schema.Permission.Role
  alias Accounts.Schema.User
  alias Accounts.Schema.Profile.Admin

  @doc """
  Renders a list of admins.
  """
  def index(%{admins: admins}) do
    %{data: for(admin <- admins, do: data(admin))}
  end

  @doc """
  Renders a single admin.
  """
  def show(%{admin: admin}) do
    %{data: data(admin)}
  end

  defp data(%Admin{} = admin) do
    %{
      id: admin.id,
      first_name: admin.first_name,
      last_name: admin.last_name,
      father_name: admin.father_name,
      mother_name: admin.mother_name,
      dob: admin.dob,
      user_id: admin.user_id,
      user: safe_user(admin)
    }
  end

  defp safe_user(%{user: user}), do: user_data(user)
  defp safe_user(_), do: nil

  defp user_data(%User{} = user) do
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

  defp user_data(_user), do: nil

  defp safe_roles(%{roles: r}) when is_list(r), do: r
  defp safe_roles(_), do: []

  defp roles_data(%Role{} = role) do
    %{
      id: role.id,
      name: role.name
    }
  end
end
