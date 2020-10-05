defmodule MehungryServerWeb.RecipeIngredientView do
  use MehungryServerWeb, :view
  alias MehungryServerWeb.RecipeIngredientView
  alias MehungryServerWeb.MeasurementUnitView
  alias MehungryServerWeb.IngredientView

  def render("index.json", %{recipe_ingredients: recipe_ingredients}) do
    %{data: render_many(recipe_ingredients, RecipeIngredientView, "recipe_ingredient.json")}
  end

  def render("show.json", %{recipe_ingredient: recipe_ingredient}) do
    %{data: render_one(recipe_ingredient, RecipeIngredientView, "recipe_ingredient.json")}
  end

  def render("recipe_ingredient.json", %{recipe_ingredient: recipe_ingredient}) do
    %{id: recipe_ingredient.id,
      quantity: recipe_ingredient.quantity,
      ingredient_allias: recipe_ingredient.ingredient_allias,
      ingredient: render_one(recipe_ingredient.ingredient, IngredientView, "ingredient.json"),
      measurement_unit: render_one(recipe_ingredient.measurement_unit, MeasurementUnitView, "measurement_unit.json")
    }
  end
end
