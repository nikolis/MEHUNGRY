defmodule MehungryServerWeb.IngredientView do
  use MehungryServerWeb, :view
  alias MehungryServerWeb.IngredientView
  alias MehungryServerWeb.CategoryView
  alias MehungryServerWeb.MeasurementUnitView

  def render("index.json", %{ingredients: ingredients}) do
    %{data: render_many(ingredients, IngredientView, "ingredient.json")}
  end

  def render("show.json", %{ingredient: ingredient}) do
    %{data: render_one(ingredient, IngredientView, "ingredient.json")}
  end

  def render("ingredient.json", %{ingredient: ingredient}) do
    %{id: ingredient.id,
      url: ingredient.url,
      name: ingredient.name,
      category: render_one(ingredient.category,
        CategoryView, "category.json"),    
      measurement_unit: render_one(ingredient.measurement_unit,
        MeasurementUnitView, "measurement_unit.json"),
   
      description: ingredient.description}
  end
end
