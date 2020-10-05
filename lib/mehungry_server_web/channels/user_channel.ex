defmodule MehungryServerWeb.VideoChannel do 
  use MehungryServerWeb, :channel

  def join("users:" <> user_id, _params, socket) do
    {:ok, socket}
  end

  def handle_info(:ping, socket) do
    count = socket.assigns[:count] || 1
    push(socket, "ping", %{count: count})
    {:noreply, assign(socket, :count, count + 155)}
  end

end
