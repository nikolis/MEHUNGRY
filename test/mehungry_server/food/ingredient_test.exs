defmodule MehungryServer.IngredientsTest do
  use MehungryServer.DataCase
  alias MehungryServer.Food.Ingredient
  alias MehungryServer.Food
  alias MehungryServer.Languages
  alias MehungryServer.Food.MeasurementUnit 
  alias MehungryServer.Food.Category

  describe "create ingredient" do
    defp category_fixture_local() do
     lang = Languages.get_language_by_name("En")
     {:ok, category} = Food.create_category(
      %{
        name: "category",
        category_translation: [%{
          language_id: lang.id,
          name: "category"
        }]
        }  
      )    
     category
    end

    defp measurement_unit_fixture_local() do
     lang = Languages.get_language_by_name("En")
     {:ok, mu} = Food.create_measurement_unit(
      %{
        name: "gram",
        translation: [
          %{
          language_id: lang.id,
          name: "gram"
        }]
        }  
      )    
     mu

    end

    Ecto.Adapters.SQL.Sandbox.checkout(MehungryServer.Repo)
    lang = Languages.get_language_by_name("En")
    @valid_attrs %{
      name: "Pork",
      description: "Pork meat",
      ingredient_translation: [
        %{
          name: "Pork meat" ,
          language_id: lang.id
        }
      ]
    }
    @invalid_atrs %{}

       
    test "with valid data insert ingredient" do
      category = category_fixture_local() 
      mu = measurement_unit_fixture()
      valid_attrs = Map.put(@valid_attrs, :category_id, category.id)
      valid_attrs = Map.put(valid_attrs, :measurement_unit_id, mu.id) 

      assert {:ok, %Ingredient{id: id} = ingredient} = Food.create_ingredient(valid_attrs)
      assert ingredient.name == "Pork"
      assert ingredient.description == "Pork meat"
      assert %Ingredient{id: ^id} = Food.get_ingredient(id)
    end

    test "delete inserted ingredient" do
      category = category_fixture_local() 
      mu = measurement_unit_fixture()
      valid_attrs = Map.put(@valid_attrs, :category_id, category.id)
      valid_attrs = Map.put(valid_attrs, :measurement_unit_id, mu.id) 

      assert {:ok, %Ingredient{id: id} = ingredient} = Food.create_ingredient(valid_attrs)
      assert {:ok, %Ingredient{} = deletedIngre} = Food.delete_ingredient(ingredient)
      assert deletedIngre.description == ingredient.description 
    end 

    test "list ingredients" do
      category = category_fixture_local() 
      mu = measurement_unit_fixture()
      valid_attrs = Map.put(@valid_attrs, :category_id, category.id)
      valid_attrs = Map.put(valid_attrs, :measurement_unit_id, mu.id) 


      assert {:ok, %Ingredient{id: id} = ingredient} = Food.create_ingredient(valid_attrs)
      assert [%Ingredient{id:  id} = retIngredient | _tail] = Food.list_ingredients()
      assert  retIngredient.description ==  retIngredient.description
    end


    test "search ingredient using translations" do
      Repo.delete_all Ingredient
      Repo.delete_all MeasurementUnit
      Repo.delete_all Category
      
      category = category_fixture_local() 
      mu = measurement_unit_fixture_local()
      valid_attrs = Map.put(@valid_attrs, :category_id, category.id)
      valid_attrs = Map.put(valid_attrs, :measurement_unit_id, mu.id) 

      assert {:ok, %Ingredient{id: id} = ingredient} = Food.create_ingredient(valid_attrs)
      assert [%Ingredient{id:  id} = retIngredient | _tail] = Food.search_ingredient("Po", "En")
      assert  retIngredient.description ==  retIngredient.description
    end

  end

end
