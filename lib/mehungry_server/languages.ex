defmodule MehungryServer.Languages do 
  import Ecto.Query
  alias MehungryServer.Language
  alias MehungryServer.Repo

  def get_language_by_name(name) do
   query =  from lang in Language, where: lang.name == ^name
   Repo.one query
  end

end
