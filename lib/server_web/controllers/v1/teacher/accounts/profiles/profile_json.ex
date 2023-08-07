defmodule ServerWeb.V1.Teacher.Accounts.Profiles.ProfileJSON do
  alias Accounts.Schema.Permission.Role
  alias Accounts.Schema.User
  alias Accounts.Schema.Profile.Teacher

  @doc """
  Renders a single teacher.
  """
  def show(%{teacher: teacher}) do
    %{data: data(teacher)}
  end

  defp data(%Teacher{} = teacher) do
    %{
      id: teacher.id,
      first_name: teacher.first_name,
      last_name: teacher.last_name,
      father_name: teacher.father_name,
      mother_name: teacher.mother_name,
      dob: teacher.dob,
      user_id: teacher.user_id,
      address_id: teacher.address_id,
      user: safe_user(teacher)
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
