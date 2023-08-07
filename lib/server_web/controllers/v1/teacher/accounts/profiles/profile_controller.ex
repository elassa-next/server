defmodule ServerWeb.V1.Teacher.Accounts.Profiles.ProfileController do
  use ServerWeb, :controller

  alias Accounts.Context.Profiles.Teachers
  alias Accounts.Schema.Profile.Teacher

  action_fallback ServerWeb.FallbackController

  plug Bodyguard.Plug.Authorize, policy: Accounts.Policy.Profile.ProfilePolicy

  def show(conn, %{"id" => user_id}) do
    teacher = Teachers.get_full_teacher_by_user!(user_id)
    render(conn, :show, teacher: teacher)
  end

  def update(conn, %{"id" => user_id, "profile" => profile_params}) do
    teacher = Teachers.get_full_teacher_by_user!(user_id)

    with {:ok, %Teacher{} = teacher} <- Teachers.profile_teacher(teacher, profile_params) do
      render(conn, :show, teacher: teacher)
    end
  end

  def delete(conn, %{"id" => user_id}) do
    teacher = Teachers.get_teacher_by_user!(user_id)

    with {:ok, _} <- Teachers.delete_teacher(teacher) do
      send_resp(conn, :no_content, "")
    end
  end
end
