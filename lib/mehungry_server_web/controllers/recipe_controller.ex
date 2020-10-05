defmodule MehungryServerWeb.RecipeController do
  use MehungryServerWeb, :controller
  use PhoenixSwagger

  alias MehungryServer.Food
  alias MehungryServer.Food.Recipe

  action_fallback MehungryServerWeb.FallbackController

  def index(conn, _params) do
    recipes = Food.list_recipes()
    render(conn, "index.json", recipes: recipes)
  end

  def index_user_recipes(conn, %{"user_id" => user_id}) do
    #recipes = Food.list_user_recipes(elem(Integer.parse(user_id),0))
    recipes = get_recipes_from_cache_or_repo(elem(Integer.parse(user_id),0))
    render(conn, "index.json", recipes: recipes)
  end

  defp  get_recipes_from_cache_or_repo(user_id) do
    ConCache.get_or_store(:user_recipes,user_id, fn ->
      Food.list_user_recipes(user_id)
    end)
  end

  swagger_path :index do
    get "/recipe/search/:name"
    description "Search recipe by Name"
    response 200, "OK", Schema.ref(:Recipe)
  end
  def search(conn, %{"name" => name}) do
    recipes = Food.search_recipe(name)
    render(conn, "index.json", recipes: recipes)
  end

  def like(conn, %{"recipe_id" => recipe_id}) do
    user = Guardian.Plug.current_resource(conn)
    {rec_id, _} = Integer.parse(recipe_id)
    Food.like_recipe(user.id, rec_id)
    conn
      |> put_status(:ok)
      |> send_resp(:ok, "Deleted")
  end
  
  def create(conn, %{"recipe" => recipe_params}) do
    user = Guardian.Plug.current_resource(conn)
    
    recipe_params = Map.put_new(recipe_params, "user_id", user.id)
    result = Food.create_recipe(recipe_params)
    case result do
      {:ok, %Recipe{} = recipe} ->
          MehungryServerWeb.Endpoint.broadcast!("recipes:1", "new_recipe",  %{data: %{recipe_id: recipe.id}})

          ConCache.dirty_delete(:user_recipes, user.id)
          recipe = MehungryServer.Repo.preload(recipe, [:user,{:recipe_ingredients,
            [
              {:measurement_unit, :translation},
              {:ingredient, [:category, :measurement_unit]}
            ]
          }])
          conn = 
            conn
            |> put_status(:created)
          render(conn,"show.json", recipe: recipe)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    recipe = Food.get_recipe!(id)
    if is_nil(recipe) do
      conn
      |> put_status(:not_found)
      |> send_resp(:not_found, "Not found")
    else
          recipe = MehungryServer.Repo.preload(recipe, [:user,{:recipe_ingredients,
            [
              {:measurement_unit, :translation},
              {:ingredient, [:category, :measurement_unit]}
            ]
          }])
 
      render(conn, "show.json", recipe: recipe)
    end
  end

  def update(conn, %{"id" => id, "recipe" => recipe_params}) do
    recipe = Food.get_recipe!(id)

    with {:ok, %Recipe{} = recipe} <- Food.update_recipe(recipe, recipe_params) do
      render(conn, "show.json", recipe: recipe)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Food.delete_recipe(id) do
      {:ok, struct} ->
        conn
        |> put_status(:no_content)
        |> send_resp(:no_content, "")
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", changeset: changeset)
    end
  end



  def swagger_definitions do
  %{
    Recipe: swagger_schema do
      title "Recipe"
      description "A recipe of the application"
      properties do
        id :string, "Unique identifier", required: true
        author :string , "In case recipe was just a copy of another and user wants to give credits"
        cooking_time_lower_limit :int, "Cooking time minimum speculated in mins"
        cooking_time_upper_limit :int, "Cooking time maximum speculated in mins"
        cousine :string, "The cusine of the recipe as a general tag i.e greek cusine or vegan"
        description :string, "A small overview of the recipe"
        image_url :string, "A url of an image of a dish of this recipe"
        recipe_image_remote :string, "Same as image_url but stored in some cloud storage"
        original_url :string, "In case the recipe is just a copy of another somewere in the web"
        preperation_time_lower_limit :int, "The speculated minimum possible preperation time in mins"
        preperation_time_upper_limit :int, "The speculated maximum preperation time in mins"
        servings :string, "The servings the user will have if he follows exactly the instractions of the recipe"
        private :boolean, "Is it open to the public"
        title :string, "Some title"

        recipe_ingredients Schema.ref(:RecipeIngredients)
      end
    end,
    Recipes: swagger_schema do
      title "Recipes"
      description "A collection of Recipes"
      type :array
      items Schema.ref(:Recipe)
    end,
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
