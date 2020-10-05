defmodule MehungryServerWeb.AnnotationView do
  use MehungryServerWeb, :view

  def render("annotation.json", %{annotation: annotation}) do
    %{
      id: annotation.id,
      body: annotation.body,
      at: annotation.at,
      user: render_one(annotation.user, MehungryServerWeb.UserView, "user.json")
    }
  end

end
