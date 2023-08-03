defmodule Server.Repo.Migrations.ChangeAccounts do
  use Ecto.Migration

  alias Accounts.Migrations

  def change do
    Migrations.Users.change()

    Migrations.Permissions.Permissions.change()
    Migrations.Permissions.Roles.change()
    Migrations.Permissions.RolePermissions.change()
    Migrations.Permissions.UserRoles.change()

    Migrations.Residence.Countries.change()
    Migrations.Residence.States.change()
    Migrations.Residence.Cities.change()
    Migrations.Residence.Addresses.change()

    Migrations.Profiles.Admins.change()
    Migrations.Profiles.Teachers.change()
    Migrations.Profiles.Students.change()
  end
end
