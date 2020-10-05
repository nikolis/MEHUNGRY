defmodule MehungryServer.FakeCache do

  def get_or_store(_cache, _cache_key, func) do
    func.()
  end
end
