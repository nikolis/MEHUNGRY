defmodule MehungryServer.Repo.Migrations.IngredientTranslation do
  use Ecto.Migration


  def change do
    create table(:ingredient_translations) do
      add :name, :string
       
      add :language_id,  references(:languages, on_delete: :delete_all)
      add :ingredient_id, references(:ingredients, on_delete: :delete_all)
      
      timestamps()
    end
   
    create index(:ingredient_translations, [:name])
  end
end
