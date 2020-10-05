defmodule MehungryServer.Food.RecipeIngredient do
  use Ecto.Schema
  import Ecto.Changeset
  alias MehungryServer.Food.MeasurementUnit


  schema "recipe_ingredients" do
    field :quantity, :float
    field :ingredient_allias, :string    
    
    belongs_to :recipe, MehungryServer.Food.Recipe
    belongs_to :measurement_unit, MehungryServer.Food.MeasurementUnit
    belongs_to :ingredient, MehungryServer.Food.Ingredient
    
    timestamps()
  end

  @doc false
  def changeset(recipe_ingredient, attrs) do
    """
      The attrs transformation code should be moved to the Food module
    """ 
    recipe_ingredient
    |> cast(attrs, [:quantity, :ingredient_allias, :measurement_unit_id, :ingredient_id, :recipe_id])
    |> validate_required([:quantity])
  end
end
