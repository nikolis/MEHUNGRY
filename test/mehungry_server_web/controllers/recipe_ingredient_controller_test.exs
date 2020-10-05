defmodule MehungryServerWeb.RecipeIngredientControllerTest do
  use MehungryServerWeb.ConnCase

  """
  alias MehungryServer.Food
  alias MehungryServer.Food.RecipeIngredient

  @create_attrs %{
    quantity: 120.5
  }
  @update_attrs %{
    quantity: 456.7
  }
  @invalid_attrs %{quantity: nil}

  def fixture(:recipe_ingredient) do
    {:ok, recipe_ingredient} = Food.create_recipe_ingredient(@create_attrs)
    recipe_ingredient
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all recipe_ingredients", %{conn: conn} do
      conn = get(conn, Routes.recipe_ingredient_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create recipe_ingredient" do
    test "renders recipe_ingredient when data is valid", %{conn: conn} do
      conn = post(conn, Routes.recipe_ingredient_path(conn, :create), recipe_ingredient: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.recipe_ingredient_path(conn, :show, id))

      assert %{
               "id" => id,
               "quantity" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.recipe_ingredient_path(conn, :create), recipe_ingredient: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update recipe_ingredient" do
    setup [:create_recipe_ingredient]

    test "renders recipe_ingredient when data is valid", %{conn: conn, recipe_ingredient: %RecipeIngredient{id: id} = recipe_ingredient} do
      conn = put(conn, Routes.recipe_ingredient_path(conn, :update, recipe_ingredient), recipe_ingredient: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.recipe_ingredient_path(conn, :show, id))

      assert %{
               "id" => id,
               "quantity" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, recipe_ingredient: recipe_ingredient} do
      conn = put(conn, Routes.recipe_ingredient_path(conn, :update, recipe_ingredient), recipe_ingredient: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete recipe_ingredient" do
    setup [:create_recipe_ingredient]

    test "deletes chosen recipe_ingredient", %{conn: conn, recipe_ingredient: recipe_ingredient} do
      conn = delete(conn, Routes.recipe_ingredient_path(conn, :delete, recipe_ingredient))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.recipe_ingredient_path(conn, :show, recipe_ingredient))
      end
    end
  end

  defp create_recipe_ingredient(_) do
    recipe_ingredient = fixture(:recipe_ingredient)
    {:ok, recipe_ingredient: recipe_ingredient}
    end
"""
end
