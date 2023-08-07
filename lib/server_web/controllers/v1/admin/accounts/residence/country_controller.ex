defmodule ServerWeb.V1.Admin.Accounts.Residence.CountryController do
  use ServerWeb, :controller

  alias Accounts.Context.Residence.Countries
  alias Accounts.Schema.Residence.Country

  action_fallback ServerWeb.FallbackController

  plug Bodyguard.Plug.Authorize, policy: Accounts.Policy.Residence.CountryPolicy

  def index(conn, _params) do
    countries = Countries.list_countries()
    render(conn, :index, countries: countries)
  end

  def create(conn, %{"country" => country_params}) do
    with {:ok, %Country{} = country} <- Countries.create_country(country_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/v1/admin/accounts/countries/#{country}")
      |> render(:show, country: country)
    end
  end

  def show(conn, %{"id" => id}) do
    country = Countries.get_country!(id)
    render(conn, :show, country: country)
  end

  def update(conn, %{"id" => id, "country" => country_params}) do
    country = Countries.get_country!(id)

    with {:ok, %Country{} = country} <- Countries.update_country(country, country_params) do
      render(conn, :show, country: country)
    end
  end

  def delete(conn, %{"id" => id}) do
    country = Countries.get_country!(id)

    with {:ok, %Country{}} <- Countries.delete_country(country) do
      send_resp(conn, :no_content, "")
    end
  end
end
