defmodule MehungryServer.Food.Category do
  use Ecto.Schema

  import Ecto.Changeset

  alias  MehungryServer.Food.CategoryTranslation

  schema "categories" do
    field :name, :string
    field :description, :string

    has_many :category_translation, CategoryTranslation
    timestamps()
  end

  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description])
    |> cast_assoc(:category_translation, with: &MehungryServer.Food.CategoryTranslation.changeset/2)
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

end
