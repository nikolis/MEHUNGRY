defmodule MehungryServer.MealPlanTest do 
  
  use MehungryServer.DataCase
  require Logger
 
  alias MehungryServer.TestDataHelpers

  alias MehungryServer.Accounts
  alias MehungryServer.Accounts.User

  alias MehungryServer.Food
  alias MehungryServer.Food.Recipe

  alias MehungryServer.Plans
  alias MehungryServer.Plans.Meal
  alias MehungryServer.Plans.DailyMealPlan
  alias MehungryServer.Plans.MealPlan

  def create_recipe(_) do
      mu = TestDataHelpers.measurement_unit_fixture()
      ingredient = TestDataHelpers.ingredient_fixture()
    {:ok, lang} = Repo.insert(MehungryServer.Language.changeset(%MehungryServer.Language{},%{"name" => "Grsdfsd"}))
      TestDataHelpers.user_fixture
      [%User{name: "Some user"} = user] = MehungryServer.Accounts.list_users 
      valid_attrs = %{"author" => "Nikolaos Galerakis",
        "cousine" => "Without boarders",
        "description" => "a recipe I just invented 23",
        "servings" => 4,
        "title" => "my great recipe title fdsfsf",
        "user" => user,
        "language_id" => lang.id,
        "title" => "tst1",
        "steps" => [%{"title" => "dsa","description" => "asdfasdf"}],
        "recipe_ingredients" => [ 
          %{"quantity" => 20, 
            "measurement_unit_id" => mu.id, 
            "ingredient_id" =>  ingredient.id}, 
          %{"quantity" => 30, 
            "measurement_unit_id" => mu.id,
            "ingredient_id" => ingredient.id}
        ] 
      }
     result =   Food.create_recipe(valid_attrs)
    case result do
      {:ok, _recipe} ->
        :ok
      {:error, error} ->
        :error
    end
  end

  describe "create meal_plan" do 
    setup [:create_recipe]

    test "save meal plan" do
      [recipe | _tail] = Food.list_recipes
      valid_attrs = %{ 
        title: "some meal plan",
        description: "some description",
        daily_meal_plans: [
          %{
            daily_meal_plan_title: "some title",
            increasing_number: 1,
            meals: [
              %{
              meal_title: "breakfast",
              recipe_id: recipe.id,
              }
            ]
          }
        ]
      }
      
      assert {:ok, %MealPlan{id: id}} = Plans.create_meal_plan(valid_attrs)
      mealPlan = Plans.get_meal_plan!(id)
      assert mealPlan.title == "some meal plan"
      assert (length mealPlan.daily_meal_plans) == 1
      [head | tail ]  = mealPlan.daily_meal_plans 
      assert (length head.meals) == 1
      [headMeal | tail ] = head.meals
      assert headMeal.recipe.servings == 4
      assert (length headMeal.recipe.recipe_ingredients) == 2
      [recipeIngredient | restOfThem] = headMeal.recipe.recipe_ingredients
      assert recipeIngredient.quantity == 30
      assert recipeIngredient.ingredient.name == "Pork meat"
      assert recipeIngredient.measurement_unit.name == "gram"

    end

  end  

end
