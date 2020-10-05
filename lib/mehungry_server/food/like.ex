defmodule MehungryServer.Food.Like do
  use Ecto.Schema
  import Ecto.Changeset

  schema "likes" do
    field :at, :integer

    belongs_to :user, MehungryServer.Accounts.User
    belongs_to :recipe, MehungryServer.Food.Recipe

    timestamps()
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:at])
    |> validate_required([:at])
  end
end
