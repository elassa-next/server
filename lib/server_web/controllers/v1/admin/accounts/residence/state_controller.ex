defmodule ServerWeb.V1.Admin.Accounts.Residence.StateController do
  use ServerWeb, :controller

  alias Accounts.Context.Residence.States
  alias Accounts.Schema.Residence.State

  action_fallback ServerWeb.FallbackController

  plug Bodyguard.Plug.Authorize, policy: Accounts.Policy.Residence.StatePolicy

  def index(conn, _params) do
    states = States.list_states()
    render(conn, :index, states: states)
  end

  def create(conn, %{"state" => state_params}) do
    with {:ok, %State{} = state} <- States.create_state(state_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/v1/admin/accounts/states/#{state}")
      |> render(:show, state: state)
    end
  end

  def show(conn, %{"id" => id}) do
    state = States.get_state!(id)
    render(conn, :show, state: state)
  end

  def update(conn, %{"id" => id, "state" => state_params}) do
    state = States.get_state!(id)

    with {:ok, %State{} = state} <- States.update_state(state, state_params) do
      render(conn, :show, state: state)
    end
  end

  def delete(conn, %{"id" => id}) do
    state = States.get_state!(id)

    with {:ok, %State{}} <- States.delete_state(state) do
      send_resp(conn, :no_content, "")
    end
  end
end
