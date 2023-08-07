defmodule ServerWeb.V1.Admin.Accounts.Profiles.TeacherController do
  use ServerWeb, :controller

  alias Accounts.Context.Profiles.Teachers
  alias Accounts.Schema.Profile.Teacher

  action_fallback ServerWeb.FallbackController

  plug Bodyguard.Plug.Authorize, policy: Accounts.Policy.Profile.TeacherPolicy

  def index(conn, _params) do
    teachers = Teachers.list_teachers()
    render(conn, :index, teachers: teachers)
  end

  def create(conn, %{"teacher" => teacher_params}) do
    with {:ok, %Teacher{} = teacher} <- Teachers.create_teacher(teacher_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/v1/admin/accounts/teachers/#{teacher}")
      |> render(:show, teacher: teacher)
    end
  end

  def show(conn, %{"id" => id}) do
    teacher = Teachers.get_full_teacher!(id)
    render(conn, :show, teacher: teacher)
  end

  def update(conn, %{"id" => id, "teacher" => teacher_params}) do
    teacher = Teachers.get_teacher!(id)

    with {:ok, %Teacher{} = teacher} <- Teachers.update_teacher(teacher, teacher_params) do
      render(conn, :show, teacher: teacher)
    end
  end

  def delete(conn, %{"id" => id}) do
    teacher = Teachers.get_teacher!(id)

    with {:ok, %Teacher{}} <- Teachers.delete_teacher(teacher) do
      send_resp(conn, :no_content, "")
    end
  end
end
