defmodule MehungryServer.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset
  
  alias MehungryServer.Accounts.Credential
  alias MehungryServer.Food.Recipe

  schema "users" do
    field :name, :string
    field :last_name, :string
    field :facebook_id, :string
    field :first_name, :string

    has_one :credential, Credential    
    has_many :recipe, Recipe
 
    many_to_many :follow, MehungryServer.Accounts.User, join_through: "follows", 
    join_keys: [user_id: :id, follow_id: :id]

    many_to_many :followers, MehungryServer.Accounts.User, join_through: "follows",
    join_keys: [follow_id: :id, user_id: :id] 
 
    timestamps()
  end
    
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name,:first_name, :last_name, :facebook_id]) 
    |> validate_required([:name, :last_name, :first_name])
    |> unique_constraint(:facebook_id)
  end
    
  def registration_changeset(user, attrs) do
    user                       
    |> cast(attrs, [:name,:first_name, :last_name, :facebook_id]) 
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end

end
