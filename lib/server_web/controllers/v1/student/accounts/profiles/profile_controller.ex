defmodule ServerWeb.V1.Student.Accounts.Profiles.ProfileController do
  use ServerWeb, :controller

  alias Accounts.Context.Profiles.Students
  alias Accounts.Schema.Profile.Student

  action_fallback ServerWeb.FallbackController

  plug Bodyguard.Plug.Authorize, policy: Accounts.Policy.Profile.ProfilePolicy

  def show(conn, %{"id" => user_id}) do
    student = Students.get_full_student_by_user!(user_id)
    render(conn, :show, student: student)
  end

  def update(conn, %{"id" => user_id, "profile" => profile_params}) do
    student = Students.get_full_student_by_user!(user_id)

    with {:ok, %Student{} = student} <- Students.profile_student(student, profile_params) do
      render(conn, :show, student: student)
    end
  end

  def delete(conn, %{"id" => user_id}) do
    student = Students.get_student_by_user!(user_id)

    with {:ok, _} <- Students.delete_student(student) do
      send_resp(conn, :no_content, "")
    end
  end
end
