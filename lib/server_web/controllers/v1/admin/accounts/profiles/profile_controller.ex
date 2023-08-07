defmodule ServerWeb.V1.Admin.Accounts.Profiles.ProfileController do
  use ServerWeb, :controller

  alias Accounts.Context.Profiles.Admins
  alias Accounts.Schema.Profile.Admin

  action_fallback ServerWeb.FallbackController

  plug Bodyguard.Plug.Authorize, policy: Accounts.Policy.Profile.ProfilePolicy

  def show(conn, %{"id" => user_id}) do
    admin = Admins.get_full_admin_by_user!(user_id)
    render(conn, :show, admin: admin)
  end

  def update(conn, %{"id" => user_id, "profile" => profile_params}) do
    admin = Admins.get_full_admin_by_user!(user_id)

    with {:ok, %Admin{} = admin} <- Admins.profile_admin(admin, profile_params) do
      render(conn, :show, admin: admin)
    end
  end

  def delete(conn, %{"id" => user_id}) do
    admin = Admins.get_admin_by_user!(user_id)

    with {:ok, _} <- Admins.delete_admin(admin) do
      send_resp(conn, :no_content, "")
    end
  end
end
