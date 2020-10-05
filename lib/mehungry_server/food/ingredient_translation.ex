defmodule MehungryServer.Food.IngredientTranslation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ingredient_translations" do
    field :name, :string

    belongs_to :ingredient, MehungryServer.Food.Ingredient
    belongs_to :language, MehungryServer.Language
    
    timestamps()
  end

  def changeset(ingredient_translation, attrs) do
    ingredient_translation
    |> cast(attrs, [:name, :language_id])
    |> validate_required([:name, :language_id])
    |> unique_constraint(:name)
  end

end
