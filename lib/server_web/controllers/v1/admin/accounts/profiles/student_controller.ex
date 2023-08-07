defmodule ServerWeb.V1.Admin.Accounts.Profiles.StudentController do
  use ServerWeb, :controller

  alias Accounts.Context.Profiles.Students
  alias Accounts.Schema.Profile.Student

  action_fallback ServerWeb.FallbackController

  plug Bodyguard.Plug.Authorize, policy: Accounts.Policy.Profile.StudentPolicy

  def index(conn, _params) do
    students = Students.list_students()
    render(conn, :index, students: students)
  end

  def create(conn, %{"student" => student_params}) do
    with {:ok, %Student{} = student} <- Students.create_student(student_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/v1/admin/accounts/students/#{student}")
      |> render(:show, student: student)
    end
  end

  def show(conn, %{"id" => id}) do
    student = Students.get_full_student!(id)
    render(conn, :show, student: student)
  end

  def update(conn, %{"id" => id, "student" => student_params}) do
    student = Students.get_student!(id)

    with {:ok, %Student{} = student} <- Students.update_student(student, student_params) do
      render(conn, :show, student: student)
    end
  end

  def delete(conn, %{"id" => id}) do
    student = Students.get_student!(id)

    with {:ok, %Student{}} <- Students.delete_student(student) do
      send_resp(conn, :no_content, "")
    end
  end
end
