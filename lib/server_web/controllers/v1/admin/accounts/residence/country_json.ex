defmodule ServerWeb.V1.Admin.Accounts.Residence.CountryJSON do
  alias Accounts.Schema.Residence.Country

  @doc """
  Renders a list of countries.
  """
  def index(%{countries: countries}) do
    %{data: for(country <- countries, do: data(country))}
  end

  @doc """
  Renders a single country.
  """
  def show(%{country: country}) do
    %{data: data(country)}
  end

  defp data(%Country{} = country) do
    %{
      id: country.id,
      name: country.name
    }
  end
end
