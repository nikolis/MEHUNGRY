defmodule MehungryServer.Food.Annotation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "annotations" do
    field :at, :integer
    field :body, :string

    belongs_to :user, MehungryServer.Accounts.User
    belongs_to :recipe, MehungryServer.Food.Recipe
    
    timestamps()
  end

  @doc false
  def changeset(annotation, attrs) do
    annotation
    |> cast(attrs, [:body, :at])
    |> validate_required([:body, :at])
  end
end
