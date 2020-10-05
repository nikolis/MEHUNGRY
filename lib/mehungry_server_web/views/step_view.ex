defmodule MehungryServerWeb.StepView do
  use MehungryServerWeb, :view

  def render("step.json", %{step: step}) do
    %{
      title: step.title,
      description: step.description
    }
  end

end
