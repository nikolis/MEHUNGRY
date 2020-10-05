defmodule MehungryServerWeb.Router do
  use MehungryServerWeb, :router

  alias MehungryServerWeb.Guardian

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

  end

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug, origin: "*"
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/api/swagger" do
      forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :mehungry_server, swagger_file: "swagger.json"
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MehungryServerWeb.Telemetry
    end
   end



  scope "/api/v1/", MehungryServerWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/ingredient/search/:name/:language", IngredientController, :search   
    resources "/ingredient", IngredientController, only: [:create, :show, :update, :delete, :index]   

    resources "/recipe", RecipeController, only: [:create, :show, :update, :delete, :index] 
    get "/recipe/search/:name", RecipeController, :search
    get "/recipe/user/:user_id", RecipeController, :index_user_recipes 
    get "/recipe/user/like/:recipe_id", RecipeController, :like

    resources "/measurement_unit", MeasurementUnitController, only: [:create, :show, :update, :delete, :index]
    get "/measurement_unit/search/:name/:language", MeasurementUnitController, :search 

    get "/category", CategoryController, :index 
  
    resources "/plan", MealPlanController, only: [:create, :show, :update, :delete, :index]
    get "/user/:id", UserController, :get
    get "/user/search/:user_name", UserController, :search_user
    get "/user/follow/:user_id", UserController, :follow_user
    get "/user/likes/:user_id", LikeController, :get_likes
  end 

  scope "/api/v1", MehungryServerWeb do
     pipe_through :api
     
     post "/login/facebook", LoginController, :login_by_facebook_token
     post "/login/credentials", LoginController, :login_with_credential 
     resources "/users", UserController, only: [:create, :show] 
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Mehungry",
        basePath: "/api/v1" 
      }
    }
  end


end
