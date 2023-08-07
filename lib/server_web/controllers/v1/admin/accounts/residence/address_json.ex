defmodule ServerWeb.V1.Admin.Accounts.Residence.AddressJSON do
  alias Accounts.Schema.Residence.Address

  @doc """
  Renders a list of addresses.
  """
  def index(%{addresses: addresses}) do
    %{data: for(address <- addresses, do: data(address))}
  end

  @doc """
  Renders a single address.
  """
  def show(%{address: address}) do
    %{data: data(address)}
  end

  defp data(%Address{} = address) do
    %{
      id: address.id,
      building_no: address.building_no,
      street_no: address.street_no,
      neighborhood: address.neighborhood
    }
  end
end
