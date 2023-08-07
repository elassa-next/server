defmodule ServerWeb.V1.Student.Accounts.Profiles.ProfileJSON do
  alias Accounts.Schema.Permission.Role
  alias Accounts.Schema.User
  alias Accounts.Schema.Profile.Student

  @doc """
  Renders a single student.
  """
  def show(%{student: student}) do
    %{data: data(student)}
  end

  defp data(%Student{} = student) do
    %{
      id: student.id,
      first_name: student.first_name,
      last_name: student.last_name,
      father_name: student.father_name,
      mother_name: student.mother_name,
      dob: student.dob,
      user_id: student.user_id,
      address_id: student.address_id,
      user: safe_user(student)
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
