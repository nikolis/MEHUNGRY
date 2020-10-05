defmodule MehungryServer.RecipeTest do
  
  use MehungryServer.DataCase
  require Logger
  

  alias MehungryServer.Food
  alias MehungryServer.Food.Ingredient
  alias MehungryServer.Food.MeasurementUnit
  alias MehungryServer.Food.RecipeIngredient
  alias MehungryServer.Food.Recipe
  alias MehungryServer.Accounts.User
  alias MehungryServer.TestDataHelpers
  alias MehungryServer.Languages

  describe "create recipe_ingredient" do
    setup do
      {:ok, user = TestDataHelpers.user_fixture}
     :ok
    end 

    defp recipe_fixture_local() do
      mu = TestDataHelpers.measurement_unit_fixture()
      ingredient = TestDataHelpers.ingredient_fixture()
      lang = Languages.get_language_by_name("En")

      #TestDataHelpers.user_fixture
      [%User{name: "Some user"} = user] = MehungryServer.Accounts.list_users 
      valid_attrs = %{"author" => "Nikolaos Galerakis",
        "cousine" => "Without boarders",
        "description" => "a recipe I just invented",
        "servings" => 4,
        "title" => "tst1",
        "user" => user,
        "language_id" => lang.id,
        "title" => "tst1 gluten-free",
        "steps" => [%{"title" => "dsa","description" => "asdfasdf gluten-free"}],
        "recipe_ingredients" => [ 
          %{"quantity" => 20, 
            "measurement_unit_id" => mu.id, 
            "ingredient_id" =>  ingredient.id,
            "ingredient_allias" => "Pork"
          }, 
          %{"quantity" => 30, 
            "measurement_unit_id" => mu.id,
            "ingredient_id" => ingredient.id}
        ] 
      }
      result =   Food.create_recipe(valid_attrs)
      result
    end

    test "with valid attrs create" do
      result = recipe_fixture_local() 
      assert {:ok, %Recipe{id: id}} = result
      recipe = Food.get_recipe!(id)
      assert recipe.cousine == "Without boarders"
      assert recipe.description == "a recipe I just invented"
      assert recipe.title == "tst1 gluten-free"
      assert (length recipe.recipe_ingredients) == 2
    end
    
   

    test "search recipe" do
      result = recipe_fixture_local
      assert {:ok, %Recipe{id: id}} = result
      recipe = Food.get_recipe!(id)
      recipeSearch = Food.search_recipe("tst")
      assert [%Recipe{id: id} = recipeRet] = recipeSearch
    end

    test "search recipe using title content" do
      result = recipe_fixture_local
      assert {:ok, %Recipe{id: id}} = result
      recipe = Food.get_recipe!(id)
      recipeSearch = Food.search_recipe("gluten free")
      assert [%Recipe{id: id} = recipeRet] = recipeSearch

     end

    test "search recipe using recipe ingredient alias" do
      result = recipe_fixture_local
      assert {:ok, %Recipe{id: id}} = result
      recipe = Food.get_recipe!(id)
      recipeSearch = Food.search_recipe(" Pork")
      assert [%Recipe{id: id} = recipeRet] = recipeSearch

    end

    test "search recipe using ingredients translation" do
      result = recipe_fixture_local
      assert {:ok, %Recipe{id: id}} = result
      recipe = Food.get_recipe!(id)
      recipeSearch = Food.search_recipe(" χειρινο")
      assert [%Recipe{id: id} = recipeRet] = recipeSearch

     end


  end
 

end
