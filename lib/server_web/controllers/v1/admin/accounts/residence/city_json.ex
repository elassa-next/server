defmodule ServerWeb.V1.Admin.Accounts.Residence.CityJSON do
  alias Accounts.Schema.Residence.City

  @doc """
  Renders a list of cities.
  """
  def index(%{cities: cities}) do
    %{data: for(city <- cities, do: data(city))}
  end

  @doc """
  Renders a single city.
  """
  def show(%{city: city}) do
    %{data: data(city)}
  end

  defp data(%City{} = city) do
    %{
      id: city.id,
      name: city.name
    }
  end
end
