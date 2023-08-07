defmodule ServerWeb.V1.Admin.Accounts.Residence.AddressController do
  use ServerWeb, :controller

  alias Accounts.Context.Residence.Addresses
  alias Accounts.Schema.Residence.Address

  action_fallback ServerWeb.FallbackController

  plug Bodyguard.Plug.Authorize, policy: Accounts.Policy.Residence.AddressPolicy

  def index(conn, _params) do
    addresses = Addresses.list_addresses()
    render(conn, :index, addresses: addresses)
  end

  def create(conn, %{"address" => address_params}) do
    with {:ok, %Address{} = address} <- Addresses.create_address(address_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/v1/admin/accounts/addresses/#{address}")
      |> render(:show, address: address)
    end
  end

  def show(conn, %{"id" => id}) do
    address = Addresses.get_address!(id)
    render(conn, :show, address: address)
  end

  def update(conn, %{"id" => id, "address" => address_params}) do
    address = Addresses.get_address!(id)

    with {:ok, %Address{} = address} <- Addresses.update_address(address, address_params) do
      render(conn, :show, address: address)
    end
  end

  def delete(conn, %{"id" => id}) do
    address = Addresses.get_address!(id)

    with {:ok, %Address{}} <- Addresses.delete_address(address) do
      send_resp(conn, :no_content, "")
    end
  end
end
