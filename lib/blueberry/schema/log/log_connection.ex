defmodule Blueberry.LogConnection do
  use Ecto.Schema

  schema "log_connection" do
    field(:ip, :string)
    field(:country, :string)
  end

  @spec insert(String.t(), String.t()) :: :ok
  def insert(ip, country) do
    %Blueberry.LogConnection{ip: ip, country: country}
    |> Blueberry.Log.Repo.insert()

    :ok
  end
end
