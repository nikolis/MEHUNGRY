defmodule MehungryServer.AccountsTest do
  use MehungryServer.DataCase

  alias MehungryServer.Accounts
  alias MehungryServer.Accounts.User

  describe "register_user/1" do
    @valid_attrs %{
      name: "User",
      credential: %{email: "eva@test", password: "secred"}
    }
    @invalid_attrs %{}

    test "with valid data inserts user" do

      assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)
      assert user.name == "User"
      assert user.credential.email == "eva@test"
      assert [%User{id: ^id}] = Accounts.list_users() 

    end

    test "with invalid data does not insert user" do
      assert {:error, _changeset} = Accounts.register_user(@invalid_attrs)
      assert Accounts.list_users() == []
    end 

  end

end
