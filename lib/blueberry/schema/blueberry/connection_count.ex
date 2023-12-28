defmodule Schema.ConnectionCount do
  @moduledoc """
  페이지 접속 카운트 DB 테이블
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "connection_count" do
    field(:ip, :string)
    field(:country, :string)
    field(:count, :integer)
  end

  @spec changeset(Ecto.Schema.t(), map()) :: Ecto.Changeset.t()
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, ~w(ip country count)a)
    |> validate_required(~w(ip country)a)
  end

  @spec upsert(String.t(), String.t()) :: :ok
  def upsert(ip, country) do
    changeset = changeset(%Schema.ConnectionCount{}, %{ip: ip, country: country})

    case Blueberry.Repo.get_by(Schema.ConnectionCount, ip: ip) do
      nil ->
        Blueberry.Repo.insert!(changeset)

      record ->
        count = record.count || 0
        Blueberry.Repo.update!(Schema.ConnectionCount.changeset(record, %{count: count + 1}))
    end

    :ok
  end
end
