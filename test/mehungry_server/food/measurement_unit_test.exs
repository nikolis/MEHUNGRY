defmodule MehungryServer.MeasurementUnitTest do
  use MehungryServer.DataCase
  alias MehungryServer.Food.MeasurementUnit 
  alias MehungryServer.Languages
  alias MehungryServer.Food
  alias MehungryServer.Food.MeasurementUnitTranslation
  alias MehungryServer.Food.Ingredient

  describe "measurement unit crud test" do

    Ecto.Adapters.SQL.Sandbox.checkout(MehungryServer.Repo)

    Repo.delete_all Ingredient
    Repo.delete_all MeasurementUnit
    Repo.delete_all MeasurementUnitTranslation

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
    assert mu.name == "gram"
    mu = Repo.preload(mu, :translation) 
    assert [%MeasurementUnitTranslation{} = translation] = mu.translation
    assert translation.language_id == lang.id
    assert translation.measurement_unit_id == mu.id

  end

end

