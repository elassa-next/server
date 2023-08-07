defmodule ServerWeb.V1.Admin.Accounts.Residence.StateJSON do
  alias Accounts.Schema.Residence.State

  @doc """
  Renders a list of states.
  """
  def index(%{states: states}) do
    %{data: for(state <- states, do: data(state))}
  end

  @doc """
  Renders a single state.
  """
  def show(%{state: state}) do
    %{data: data(state)}
  end

  defp data(%State{} = state) do
    %{
      id: state.id,
      name: state.name
    }
  end
end
