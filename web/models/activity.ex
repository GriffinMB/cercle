defmodule CercleApi.Activity do
  use CercleApi.Web, :model
  use Timex

  @derive {Poison.Encoder, only: [
              :id, :title, :is_done, :due_date,
              :company_id, :contact_id, :user_id, :opportunity_id, :user, :contact
            ]}

  schema "activities" do
    belongs_to :opportunity, CercleApi.Opportunity
    belongs_to :user, CercleApi.User
    belongs_to :contact, CercleApi.Contact
    belongs_to :company, CercleApi.Company
    field :due_date, Ecto.DateTime
    field :is_done, :boolean, default: false
    field :title, :string

    timestamps
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [
          :user_id, :contact_id, :company_id, :due_date, :is_done,
          :title, :opportunity_id])
    |> validate_required([:user_id, :contact_id, :company_id])
  end

  def today(user) do
    from_time = user.time_zone |> Timex.now |> Timex.beginning_of_day
    to_time = user.time_zone |> Timex.now |> Timex.end_of_day

    query = from p in __MODULE__,
      where: p.is_done == false,
      where: p.user_id == ^user.id,
      where: p.company_id == ^user.company_id,
      where: p.due_date  >= ^from_time,
      where: p.due_date <= ^to_time,
      order_by: [asc: p.due_date]

    query
    |> CercleApi.Repo.all
    |> CercleApi.Repo.preload([:contact, :user])
  end

  def overdue(user) do
    from_time = user.time_zone |> Timex.now |> Timex.beginning_of_day
    to_time = user.time_zone |> Timex.now |> Timex.end_of_day

    query = from p in __MODULE__,
      where: p.is_done == false,
      where: p.user_id == ^user.id,
      where: p.company_id == ^user.company_id,
      where: p.due_date  <= ^from_time,
      where: not is_nil(p.contact_id),
      order_by: [asc: p.due_date]

    query
    |> CercleApi.Repo.all
    |> CercleApi.Repo.preload([:contact, :user])
  end

  def later(user) do
    from_time = user.time_zone |> Timex.now |> Timex.beginning_of_day
    to_time = user.time_zone |> Timex.now |> Timex.end_of_day

    query = from p in __MODULE__,
      where: p.is_done == false,
      where: p.user_id == ^user.id,
      where: p.company_id == ^user.company_id,
      where: p.due_date >= ^to_time,
      order_by: [asc: p.due_date]

    query
    |> CercleApi.Repo.all
    |> CercleApi.Repo.preload([:contact, :user])
  end
end
