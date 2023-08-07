defmodule ServerWeb.Router do
  use ServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ServerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :guest do
    plug Accounts.Guardian.GuestVerify
  end

  pipeline :admin do
    plug Accounts.Guardian.AdminVerify
  end

  pipeline :teacher do
    plug Accounts.Guardian.TeacherVerify
  end

  pipeline :student do
    plug Accounts.Guardian.StudentVerify
  end

  scope "/", ServerWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/v1", ServerWeb.V1, as: :v1 do
    pipe_through [:api]

    scope "/admin", Admin, as: :admin do
      pipe_through [:admin]

      scope "/accounts", Accounts, as: :accounts do
        resources "/permissions", Permissions.PermissionController, only: [:index]
        resources "/roles", Permissions.RoleController, except: [:new, :edit]
        post "/roles/:id/assign", Permissions.RoleController, :assign

        resources "/users", UserController, except: [:new, :edit]
        post "/users/:id/assign", UserController, :assign

        resources "/admins", Profiles.AdminController, except: [:new, :edit]
        resources "/teachers", Profiles.TeacherController, except: [:new, :edit]
        resources "/students", Profiles.StudentController, except: [:new, :edit]

        resources "/profile", Profiles.ProfileController, only: [:show, :update, :delete]

        resources "/countries", Residence.CountryController, except: [:new, :edit]
        resources "/states", Residence.StateController, except: [:new, :edit]
        resources "/cities", Residence.CityController, except: [:new, :edit]
        resources "/addresses", Residence.AddressController, except: [:new, :edit]
      end
    end

    scope "/admin", Admin, as: :admin do
      pipe_through [:guest]

      post "/login", SessionController, :create
    end

    scope "/teacher", Teacher, as: :teacher do
      pipe_through [:teacher]

      scope "/accounts", Accounts, as: :accounts do
        resources "/profile", Profiles.ProfileController, only: [:show, :update, :delete]
      end
    end

    scope "/teacher", Teacher, as: :teacher do
      pipe_through [:guest]

      post "/login", SessionController, :create
    end

    scope "/student", Student, as: :student do
      pipe_through [:student]

      scope "/accounts", Accounts, as: :accounts do
        resources "/profile", Profiles.ProfileController, only: [:show, :update, :delete]
      end
    end

    scope "/student", Student, as: :student do
      pipe_through [:guest]

      post "/login", SessionController, :create
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:server, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ServerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
