defmodule MehungryServer.Language do
  use Ecto.Schema

  import Ecto.Changeset

  schema "languages" do
    field :name, :string
   

    timestamps()
  end

  def changeset(language, attrs) do
    language
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

 
end 
