defmodule MehungryServer.TestDataHelpers do
  alias MehungryServer.Languages

  alias MehungryServer.{
    Accounts,
    Food
  }

  def user_fixture(attrs \\ %{}) do
    username = "user#{System.unique_integer([:positive])}"
    
    {:ok, user} = 
      attrs
      |> Enum.into(%{
        name: "Some user",
        username: username,
        credential: %{
          email: attrs[:email] || "#{username}@example.com",
          password: attrs[:password] || "supersecret",
        }
      })
      |> Accounts.register_user()
    user
  end

  def ingredient_fixture(attrs \\ %{}) do
    lang = Languages.get_language_by_name("Gr")
    attrs = 
      Enum.into(attrs, %{
        name: "Pork meat",
        url: "http://example.com",
        description: "a description",
        ingredient_translation: [
        %{
          name: "χειρινο" ,
          language_id: lang.id
        }
        ]

      })

      category = category_fixture() 
      mu = measurement_unit_fixture()
      valid_attrs = Map.put(attrs, :category_id, category.id)
      valid_attrs = Map.put(valid_attrs, :measurement_unit_id, mu.id) 

    {:ok, ingredient} = Food.create_ingredient(valid_attrs)
    
    ingredient  
  end

    def category_fixture() do
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

  def measurement_unit_fixture(attrs \\ %{}) do
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
 
  def recipe_ingredient_fixture(%Food.Recipe{} = recipe, %Food.Ingredient{} = ingredient, %Food.MeasurementUnit{} = mo, attrs \\ %{}) do
    
    attrs = 
      Enum.into(attrs, %{
        quantity: 3
      })
      
    {:ok, recipe_ingredient} = Food.create_recipe_ingredient(recipe, ingredient, mo, attrs)

    recipe_ingredient   
  end

  def recipe_fixture(%Accounts.User{} = user, attrs \\ %{}) do
    attrs = 
      Enum.into(attrs, %{
        title: "some title",
        author: "another author",
        cousine: "some cusine",
        description: "some description",
        servings: 4, 
      })
  end

end
