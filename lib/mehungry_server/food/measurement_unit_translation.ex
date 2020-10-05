defmodule MehungryServer.Food.MeasurementUnitTranslation do
  use Ecto.Schema

  import Ecto.Changeset

  schema "measurement_unit_translations" do
    field :name, :string

    belongs_to :language, MehungryServer.Language
    belongs_to :measurement_unit, MehungryServer.Food.Measurement_unit 
 
    timestamps()    
  end
   
  def changeset(mu_trans, attrs) do
    mu_trans
    |> cast(attrs, [:language_id, :name])
    |> validate_required([:language_id, :name])
  end




end
