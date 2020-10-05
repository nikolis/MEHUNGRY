defmodule MehungryServerWeb.RecipeIngredientController do
  use MehungryServerWeb, :controller
  use PhoenixSwagger

  alias MehungryServer.Food
  alias MehungryServer.Food.RecipeIngredient

  action_fallback MehungryServerWeb.FallbackController

  def index(conn, _params) do
    recipe_ingredients = Food.list_recipe_ingredients()
    render(conn, "index.json", recipe_ingredients: recipe_ingredients)
  end

  def create(conn, %{"recipe_ingredient" => recipe_ingredient_params}) do
    with {:ok, %RecipeIngredient{} = recipe_ingredient} <- Food.create_recipe_ingredient(recipe_ingredient_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.recipe_ingredient_path(conn, :show, recipe_ingredient))
      |> render("show.json", recipe_ingredient: recipe_ingredient)
    end
  end

  def show(conn, %{"id" => id}) do
    recipe_ingredient = Food.get_recipe_ingredient!(id)
    render(conn, "show.json", recipe_ingredient: recipe_ingredient)
  end

  def update(conn, %{"id" => id, "recipe_ingredient" => recipe_ingredient_params}) do
    recipe_ingredient = Food.get_recipe_ingredient!(id)

    with {:ok, %RecipeIngredient{} = recipe_ingredient} <- Food.update_recipe_ingredient(recipe_ingredient, recipe_ingredient_params) do
      render(conn, "show.json", recipe_ingredient: recipe_ingredient)
    end
  end

  def delete(conn, %{"id" => id}) do
    recipe_ingredient = Food.get_recipe_ingredient!(id)

    with {:ok, %RecipeIngredient{}} <- Food.delete_recipe_ingredient(recipe_ingredient) do
      send_resp(conn, :no_content, "")
    end
  end

  def swagger_definitions do
  %{
    RecipeIngredient: swagger_schema do
      title "Recipe Ingredient"
      description "A association object for ingredients with recipes"
      properties do
        quanity :float, "The quantity of the inredient contained", required: true
        ingredient_alias :string, "The name of the ingredient the user sees", required: true
        recipe_id :int, "The recipe's referenc id"
        measurement_unit Schema.ref(:MeasurementUnit) 
        ingredient_id :int, "The ingredient referenced id"
      end
    end,
    RecipeIngredients: swagger_schema do
      title "Recipe Ingredients"
      description "A collection of Recipe Ingredients"
      type :array
      items Schema.ref(:RecipeIngredient)
    end
  }
  end


end
