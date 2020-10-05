defmodule MehungryServerWeb.UserController do 
  use MehungryServerWeb, :controller

  alias MehungryServerWeb.Guardian

  alias MehungryServer.Food
  alias MehungryServer.Food.Recipe
  alias MehungryServer.Accounts
  alias MehungryServer.Account.User
  alias MehungryServerWeb.LikeView 

  action_fallback MehungryServerWeb.FallbackController 

  def get(conn, %{"id" => user_id}) do
    user = Accounts.get_user!(user_id)
    render(conn, "show.json", user: user)
  end

  def search_user(conn, %{"user_name" => user_name}) do
    users = Food.list_users()
    render(conn, "index.json", users: users)
  end

  def follow_user(conn, %{"user_id" => user_id}) do
    user_follower = Guardian.Plug.current_resource(conn)
    user_to_follow = Accounts.get_user!(user_id)
    {:ok, follow} =  Accounts.follow_user(%{user_id: user_follower.id, follow_id: user_to_follow.id})
    render(conn, "show.json", user_to_follow)
  end


  
  def create(conn, %{"user" => user_params}) do
    case  Accounts.register_user(user_params) do
      {:ok, user} ->
        #token = GreekCoin.Token.generate_new_account_token(user)
        #verification_url = user_url(token)
        #verification_email = Email.email_verification_email(user, verification_url)
        #mail_sent = Mailer.deliver_now verification_email
        conn
        |> render("show.json", user: user)
      
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)     
        |> render("error.json", changeset: changeset)
    end
  end


  def update(conn, %{"user" => user_params}) do
    user_auth = Guardian.Plug.current_resource(conn)
    user = Accounts.get_user!(user_auth.id)
    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> render("show.json", user: user)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", changeset: changeset)
    end  
  end







end
