defmodule MehungryServerWeb.LikeView do
  use MehungryServerWeb, :view

  alias MehungryServerWeb.LikeView
  alias MehungryServer.Food.Like

  def render("likes.json", %{likes: likes}) do
    %{data: render_many(likes, LikeView, "like.json")}
  end

  def render("like.json", %{like: like}) do
    %{recipe_id: like.recipe_id,
      user_id: like.user_id,
    }
  end


end
