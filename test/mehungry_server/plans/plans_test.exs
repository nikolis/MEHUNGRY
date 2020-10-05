defmodule MehungryServer.PlansTest do
  use MehungryServer.DataCase

  alias MehungryServer.Plans
"""
  describe "meal_plans" do
    alias MehungryServer.Plans.MealPlan

    @valid_attrs %{description: "some description", title: "some title"}
    @update_attrs %{description: "some updated description", title: "some updated title"}
    @invalid_attrs %{description: nil, title: nil}

    def meal_plan_fixture(attrs \\ %{}) do
      {:ok, meal_plan} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Plans.create_meal_plan()

      meal_plan
    end

    test "list_meal_plans/0 returns all meal_plans" do
      meal_plan = meal_plan_fixture()
      assert Plans.list_meal_plans() == [meal_plan]
    end

    test "get_meal_plan!/1 returns the meal_plan with given id" do
      meal_plan = meal_plan_fixture()
      assert Plans.get_meal_plan!(meal_plan.id) == meal_plan
    end

    test "create_meal_plan/1 with valid data creates a meal_plan" do
      assert {:ok, %MealPlan{} = meal_plan} = Plans.create_meal_plan(@valid_attrs)
      assert meal_plan.description == "some description"
      assert meal_plan.title == "some title"
    end

    test "create_meal_plan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Plans.create_meal_plan(@invalid_attrs)
    end

    test "update_meal_plan/2 with valid data updates the meal_plan" do
      meal_plan = meal_plan_fixture()
      assert {:ok, %MealPlan{} = meal_plan} = Plans.update_meal_plan(meal_plan, @update_attrs)
      assert meal_plan.description == "some updated description"
      assert meal_plan.title == "some updated title"
    end

    test "update_meal_plan/2 with invalid data returns error changeset" do
      meal_plan = meal_plan_fixture()
      assert {:error, %Ecto.Changeset{}} = Plans.update_meal_plan(meal_plan, @invalid_attrs)
      assert meal_plan == Plans.get_meal_plan!(meal_plan.id)
    end

    test "delete_meal_plan/1 deletes the meal_plan" do
      meal_plan = meal_plan_fixture()
      assert {:ok, %MealPlan{}} = Plans.delete_meal_plan(meal_plan)
      assert_raise Ecto.NoResultsError, fn -> Plans.get_meal_plan!(meal_plan.id) end
    end

    test "change_meal_plan/1 returns a meal_plan changeset" do
      meal_plan = meal_plan_fixture()
      assert %Ecto.Changeset{} = Plans.change_meal_plan(meal_plan)
    end
  end

  describe "daily_meal_plans" do
    alias MehungryServer.Plans.DailyMealPlan

    @valid_attrs %{daily_meal_plan_title: "some daily_meal_plan_title", increasing_number: 42, meal_note: "some meal_note"}
    @update_attrs %{daily_meal_plan_title: "some updated daily_meal_plan_title", increasing_number: 43, meal_note: "some updated meal_note"}
    @invalid_attrs %{daily_meal_plan_title: nil, increasing_number: nil, meal_note: nil}

    def daily_meal_plan_fixture(attrs \\ %{}) do
      {:ok, daily_meal_plan} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Plans.create_daily_meal_plan()

      daily_meal_plan
    end

    test "list_daily_meal_plans/0 returns all daily_meal_plans" do
      daily_meal_plan = daily_meal_plan_fixture()
      assert Plans.list_daily_meal_plans() == [daily_meal_plan]
    end

    test "get_daily_meal_plan!/1 returns the daily_meal_plan with given id" do
      daily_meal_plan = daily_meal_plan_fixture()
      assert Plans.get_daily_meal_plan!(daily_meal_plan.id) == daily_meal_plan
    end

    test "create_daily_meal_plan/1 with valid data creates a daily_meal_plan" do
      assert {:ok, %DailyMealPlan{} = daily_meal_plan} = Plans.create_daily_meal_plan(@valid_attrs)
      assert daily_meal_plan.daily_meal_plan_title == "some daily_meal_plan_title"
      assert daily_meal_plan.increasing_number == 42
      assert daily_meal_plan.meal_note == "some meal_note"
    end

    test "create_daily_meal_plan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Plans.create_daily_meal_plan(@invalid_attrs)
    end

    test "update_daily_meal_plan/2 with valid data updates the daily_meal_plan" do
      daily_meal_plan = daily_meal_plan_fixture()
      assert {:ok, %DailyMealPlan{} = daily_meal_plan} = Plans.update_daily_meal_plan(daily_meal_plan, @update_attrs)
      assert daily_meal_plan.daily_meal_plan_title == "some updated daily_meal_plan_title"
      assert daily_meal_plan.increasing_number == 43
      assert daily_meal_plan.meal_note == "some updated meal_note"
    end

    test "update_daily_meal_plan/2 with invalid data returns error changeset" do
      daily_meal_plan = daily_meal_plan_fixture()
      assert {:error, %Ecto.Changeset{}} = Plans.update_daily_meal_plan(daily_meal_plan, @invalid_attrs)
      assert daily_meal_plan == Plans.get_daily_meal_plan!(daily_meal_plan.id)
    end

    test "delete_daily_meal_plan/1 deletes the daily_meal_plan" do
      daily_meal_plan = daily_meal_plan_fixture()
      assert {:ok, %DailyMealPlan{}} = Plans.delete_daily_meal_plan(daily_meal_plan)
      assert_raise Ecto.NoResultsError, fn -> Plans.get_daily_meal_plan!(daily_meal_plan.id) end
    end

    test "change_daily_meal_plan/1 returns a daily_meal_plan changeset" do
      daily_meal_plan = daily_meal_plan_fixture()
      assert %Ecto.Changeset{} = Plans.change_daily_meal_plan(daily_meal_plan)
    end
  end

  describe "meals" do
    alias MehungryServer.Plans.Meal

    @valid_attrs %{meal_note: "some meal_note", meal_title: "some meal_title"}
    @update_attrs %{meal_note: "some updated meal_note", meal_title: "some updated meal_title"}
    @invalid_attrs %{meal_note: nil, meal_title: nil}

    def meal_fixture(attrs \\ %{}) do
      {:ok, meal} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Plans.create_meal()

      meal
    end

    test "list_meals/0 returns all meals" do
      meal = meal_fixture()
      assert Plans.list_meals() == [meal]
    end

    test "get_meal!/1 returns the meal with given id" do
      meal = meal_fixture()
      assert Plans.get_meal!(meal.id) == meal
    end

    test "create_meal/1 with valid data creates a meal" do
      assert {:ok, %Meal{} = meal} = Plans.create_meal(@valid_attrs)
      assert meal.meal_note == "some meal_note"
      assert meal.meal_title == "some meal_title"
    end

    test "create_meal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Plans.create_meal(@invalid_attrs)
    end

    test "update_meal/2 with valid data updates the meal" do
      meal = meal_fixture()
      assert {:ok, %Meal{} = meal} = Plans.update_meal(meal, @update_attrs)
      assert meal.meal_note == "some updated meal_note"
      assert meal.meal_title == "some updated meal_title"
    end

    test "update_meal/2 with invalid data returns error changeset" do
      meal = meal_fixture()
      assert {:error, %Ecto.Changeset{}} = Plans.update_meal(meal, @invalid_attrs)
      assert meal == Plans.get_meal!(meal.id)
    end

    test "delete_meal/1 deletes the meal" do
      meal = meal_fixture()
      assert {:ok, %Meal{}} = Plans.delete_meal(meal)
      assert_raise Ecto.NoResultsError, fn -> Plans.get_meal!(meal.id) end
    end

    test "change_meal/1 returns a meal changeset" do
      meal = meal_fixture()
      assert %Ecto.Changeset{} = Plans.change_meal(meal)
    end
    end
  """
end
