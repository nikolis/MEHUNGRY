defmodule MehungryServerWeb.RecipeChannel do 
  use MehungryServerWeb, :channel

  alias MehungryServer.Accounts
  alias MehungryServer.Food
  alias MehungryServerWeb.UserView
  alias MehungryServerWeb.AnnotationView


  def join("recipes:" <> recipe_id, _params, socket) do
    recipe_id = String.to_integer(recipe_id)
    recipe = Food.get_recipe!(recipe_id)
    annotations = 
      recipe
      |> Food.list_annotations()
      |> Phoenix.View.render_many(AnnotationView, "annotation.json")
    {:ok, %{annotations: annotations} ,assign(socket, :recipe_id, recipe_id)}
  end

  def broadcast_new_recipe(recipe_id) do
    MehungryServerWeb.Endpoint.broadcast!("recipe:1", "new_recipe", %{recipe_id: recipe_id})
  end

  def handle_in(event, params, socket) do
    user = Accounts.get_user!(socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    case Food.annotate_recipe(user, socket.assigns.recipe_id, params) do 
      {:ok, annotation} ->
        broadcast!(socket, "new_annotation", %{
          id: annotation.id,
          user: UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at
        })
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end


end
