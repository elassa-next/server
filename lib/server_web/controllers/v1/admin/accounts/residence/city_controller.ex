defmodule ServerWeb.V1.Admin.Accounts.Residence.CityController do
  use ServerWeb, :controller

  alias Accounts.Context.Residence.Cities
  alias Accounts.Schema.Residence.City

  action_fallback ServerWeb.FallbackController

  plug Bodyguard.Plug.Authorize, policy: Accounts.Policy.Residence.CityPolicy

  def index(conn, _params) do
    cities = Cities.list_cities()
    render(conn, :index, cities: cities)
  end

  def create(conn, %{"city" => city_params}) do
    with {:ok, %City{} = city} <- Cities.create_city(city_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/v1/admin/accounts/cities/#{city}")
      |> render(:show, city: city)
    end
  end

  def show(conn, %{"id" => id}) do
    city = Cities.get_city!(id)
    render(conn, :show, city: city)
  end

  def update(conn, %{"id" => id, "city" => city_params}) do
    city = Cities.get_city!(id)

    with {:ok, %City{} = city} <- Cities.update_city(city, city_params) do
      render(conn, :show, city: city)
    end
  end

  def delete(conn, %{"id" => id}) do
    city = Cities.get_city!(id)

    with {:ok, %City{}} <- Cities.delete_city(city) do
      send_resp(conn, :no_content, "")
    end
  end
end
