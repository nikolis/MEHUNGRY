defmodule MehungryServerWeb.RecipeControllerTest do
  use MehungryServerWeb.ConnCase
  use PhoenixSwagger.SchemaTest, "priv/static/swagger.json"

  alias MehungryServer.Food
  alias MehungryServer.Food.Recipe
  alias MehungryServer.Accounts.User
  alias MehungryServer.Accounts
  alias MehungryServer.TestDataHelpers
  alias MehungryServer.Languages

  @create_attrs %{
    author: "some author",
    cooking_time_lower_limit: 42,
    cooking_time_upper_limit: 42,
    cousine: "some cousine",
    description: "some description",
    image_url: "some image_url",
    original_url: "some original_url",
    preperation_time_lower_limit: 42,
    preperation_time_upper_limit: 42,
    servings: 42,
    title: "some title"
  }
  @update_attrs %{
    author: "some updated author",
    cooking_time_lower_limit: 43,
    cooking_time_upper_limit: 43,
    cousine: "some updated cousine",
    description: "some updated description",
    image_url: "some updated image_url",
    original_url: "some updated original_url",
    preperation_time_lower_limit: 43,
    preperation_time_upper_limit: 43,
    servings: 43,
    title: "some updated title"
  }
  @invalid_attrs %{author: nil, cooking_time_lower_limit: nil, cooking_time_upper_limit: nil, cousine: nil, description: nil, image_url: nil, original_url: nil, preperation_time_lower_limit: nil, preperation_time_upper_limit: nil, servings: nil, title: nil}

  def fixture(:recipe) do
      mu = TestDataHelpers.measurement_unit_fixture()
      ingredient = TestDataHelpers.ingredient_fixture()
      lang = Languages.get_language_by_name("En")

      #TestDataHelpers.user_fixture
      {:ok, %User{} = user} = Accounts.register_user(%{credential: %{email: "someemail@dom444ain.com", password: "123456" }})

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

    {:ok, recipe} = result
    recipe
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all recipes", %{conn: conn} do
      assert {:ok, %User{} = user} = Accounts.register_user(%{credential: %{email: "someemail@domain.com", password: "123456" }})

       conn2 =
        post(build_conn(), Routes.login_path(conn, :login_with_credential),
          credential: %{
            "email" => "someemail@domain.com",
            "password" => "123456",
            "captcha_token" => "googletoklen"
          }
        )

      body = json_response(conn2, 200)
        
      conn =
        conn
        |> put_req_header("authorization", "Bearer " <> body["jwt"])
        
 

      conn = get(conn, Routes.recipe_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create recipe" do
    test "renders recipe when data is valid", %{conn: conn, swagger_schema: schema} do
      assert {:ok, %User{} = user} = Accounts.register_user(%{credential: %{email: "someemail@domain.com", password: "123456" }})

       conn2 =
        post(build_conn(), Routes.login_path(conn, :login_with_credential),
          credential: %{
            "email" => "someemail@domain.com",
            "password" => "123456",
            "captcha_token" => "googletoklen"
          }
        )

      body = json_response(conn2, 200)
        
      conn =
        conn
        |> put_req_header("authorization", "Bearer " <> body["jwt"])
        

      mu = TestDataHelpers.measurement_unit_fixture()
      ingredient = TestDataHelpers.ingredient_fixture()
      lang = Languages.get_language_by_name("En")

      #TestDataHelpers.user_fixture
      {:ok, %User{} = user} = Accounts.register_user(%{credential: %{email: "someemail@dom444ain.com", password: "123456" }})

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

      conn = post(conn, Routes.recipe_path(conn, :create), recipe: valid_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.recipe_path(conn, :show, id))

      validate_resp_schema(conn, schema, "Recipe")

    end

    test "renders errors when data is invalid", %{conn: conn} do
      assert {:ok, %User{} = user} = Accounts.register_user(%{credential: %{email: "someemail@domain.com", password: "123456" }})

       conn2 =
        post(build_conn(), Routes.login_path(conn, :login_with_credential),
          credential: %{
            "email" => "someemail@domain.com",
            "password" => "123456",
            "captcha_token" => "googletoklen"
          }
        )

      body = json_response(conn2, 200)
        
      conn =
        conn
        |> put_req_header("authorization", "Bearer " <> body["jwt"])
        



      conn = post(conn, Routes.recipe_path(conn, :create), recipe: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update recipe" do
    setup [:create_recipe]

    test "renders recipe when data is valid", %{conn: conn, recipe: %Recipe{id: id} = recipe} do
      assert {:ok, %User{} = user} = Accounts.register_user(%{credential: %{email: "someemail@domain.com", password: "123456" }})

       conn2 =
        post(build_conn(), Routes.login_path(conn, :login_with_credential),
          credential: %{
            "email" => "someemail@domain.com",
            "password" => "123456",
            "captcha_token" => "googletoklen"
          }
        )

      body = json_response(conn2, 200)
        
      conn =
        conn
        |> put_req_header("authorization", "Bearer " <> body["jwt"])
        

      conn = put(conn, Routes.recipe_path(conn, :update, recipe), recipe: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.recipe_path(conn, :show, id))

      assert %{
               "id" => id,
               "author" => "some updated author",
               "cooking_time_lower_limit" => 43,
               "cooking_time_upper_limit" => 43,
               "cousine" => "some updated cousine",
               "description" => "some updated description",
               "image_url" => "some updated image_url",
               "original_url" => "some updated original_url",
               "preperation_time_lower_limit" => 43,
               "preperation_time_upper_limit" => 43,
               "servings" => 43,
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, recipe: recipe} do
      assert {:ok, %User{} = user} = Accounts.register_user(%{credential: %{email: "someemail@domain.com", password: "123456" }})

       conn2 =
        post(build_conn(), Routes.login_path(conn, :login_with_credential),
          credential: %{
            "email" => "someemail@domain.com",
            "password" => "123456",
            "captcha_token" => "googletoklen"
          }
        )

      body = json_response(conn2, 200)
        
      conn =
        conn
        |> put_req_header("authorization", "Bearer " <> body["jwt"])

      conn = put(conn, Routes.recipe_path(conn, :update, recipe), recipe: @invalid_attrs)
      assert json_response(conn, 422) != %{}
    end
  end

  describe "delete recipe" do
    setup [:create_recipe]

    test "deletes chosen recipe", %{conn: conn, recipe: recipe} do
      assert {:ok, %User{} = user} = Accounts.register_user(%{credential: %{email: "someemail@domain.com", password: "123456" }})

       conn2 =
        post(build_conn(), Routes.login_path(conn, :login_with_credential),
          credential: %{
            "email" => "someemail@domain.com",
            "password" => "123456",
            "captcha_token" => "googletoklen"
          }
        )

      body = json_response(conn2, 200)
        
      conn =
        conn
        |> put_req_header("authorization", "Bearer " <> body["jwt"])
        

      conn = delete(conn, Routes.recipe_path(conn, :delete, recipe))
      assert response(conn, 204)

    end
  end

  defp create_recipe(_) do
    recipe = fixture(:recipe)
    {:ok, recipe: recipe}
    end

end
