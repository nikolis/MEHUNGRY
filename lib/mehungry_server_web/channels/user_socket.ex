defmodule MehungryServerWeb.UserSocket do
  use Phoenix.Socket
 
  alias MehungryServerWeb.Guardian
  alias MehungryServer.Accounts

  ## Channels
  
  channel "users:*", MehungryServerWeb.RoomChannel
  channel "recipes:*", MehungryServerWeb.RecipeChannel
  
  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => token}, socket, _connect_info) do
    verification = Guardian.decode_and_verify(token)  
    case verification do 
      {:ok, claims} ->
        user = Accounts.get_user!(claims["sub"])
        {:ok, assign(socket, :user_id, claims["sub"])}
      {:error, _sthing} ->
        :error
    end
  end

  def connect(_params, _socket, _connect_info), do: :error

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     MehungryServerWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(socket), do: "users_socket:#{socket.assigns.user_id}"
end
